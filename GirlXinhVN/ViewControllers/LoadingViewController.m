//
//  LoadingViewController.m
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingViewController.h"
#import "AsyncURLConnection.h"
#import "NSString+Utils.h"
#import "SBJsonParser.h"
#import "Photo.h"
#import "EGOImageLoader.h"

#define kJSONDataProgress 0.0

@implementation LoadingViewController
@synthesize loadingLabel;
@synthesize progressBar;
@synthesize coverImage;
@synthesize delegate;
@synthesize parsedPhotos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)parseResult:(NSData *)data
{
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *result = [jsonParser objectWithData:data];

	NSArray *photos  = [result objectForKey:@"data"];
	parsedPhotos = [[NSMutableArray alloc] initWithCapacity:[photos count]];

	NSInteger count =0;
	for(NSDictionary *aPhotoDict in photos)
	{
		Photo *aPhoto = [[Photo alloc] init];
		aPhoto.photoID = [aPhotoDict objectForKey:@"pid"];
		aPhoto.bigPhotoURL = [aPhotoDict objectForKey:@"src_big"];
		[parsedPhotos addObject:aPhoto];
		[aPhoto release];
	}

	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentRootPath = [documentPaths objectAtIndex:0];
	[NSKeyedArchiver archiveRootObject:parsedPhotos toFile:documentRootPath];

	delta = (1 - kJSONDataProgress) / [parsedPhotos count];
	
	__block  int step = [parsedPhotos count]/20;
    __block int index = 0;

    for (Photo *aPhoto in parsedPhotos)
	{
		[[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:aPhoto.bigPhotoURL]
		                                         completion:^void(UIImage *image, NSURL *imageURL, NSError *error)
		{
			if (index % 4 == 0)
			{
				UIImageView *imageView = (UIImageView *)[self.view viewWithTag:((index /4) % 9)+1];
				imageView.image = image;
			}
			index++;

			if (index % step == 0)
			{
				progressBar.progress += 0.05;
			}
			
            if (index == [parsedPhotos count]) 
            {
                if (delegate && [delegate respondsToSelector:@selector(didFinishLoadingData:)]) {
                    [delegate didFinishLoadingData:self];
                }
            }
		}];
	}

	NSLog(@"Number of empty photo: %d", count);
	NSLog(@"Done");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	NSString *requestURL = [NSString stringByEscapingString:@"https://graph.facebook.com/fql?q=select caption, src_big from photo where aid ='108425012571651_29383'"];
	NSString *queryString = @"https://graph.facebook.com/fql?q=select pid, src_big from photo where aid =\"108425012571651_29383\"";

	[AsyncURLConnection request:[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completeBlock:^void(NSData *data) {
		NSLog(@"Finished loading.");
		progressBar.progress = kJSONDataProgress;
		[self parseResult:data];
	} errorBlock:^void(NSError *error) {
		NSLog(@"Error: %@", [error description]);
	}];


}

- (void)viewDidUnload
{
    [self setLoadingLabel:nil];
    [self setProgressBar:nil];
    [self setCoverImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [parsedPhotos release];
    [loadingLabel release];
    [progressBar release];
    [coverImage release];
    [super dealloc];
}



@end
