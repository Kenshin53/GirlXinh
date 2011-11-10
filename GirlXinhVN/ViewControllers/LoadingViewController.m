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

- (NSString *)savedPhotosFilePath
{
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentRootPath = [documentPaths objectAtIndex:0];
	NSString *savedPhotosFilePath = [documentRootPath stringByAppendingString:@"savedPhotos.plist"];
	return savedPhotosFilePath;
}

// TODO: Handle broken download.

- (void)downloadImages; {
	delta = (1 - kJSONDataProgress) / [parsedPhotos count];

	__block  int step = [parsedPhotos count]/20;
	__block int index = 0;

	for (Photo *aPhoto in parsedPhotos)
	{
		[[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:aPhoto.bigPhotoURL]
		                                         completion:^void(UIImage *image, NSURL *imageURL, NSError *error)
		{
			aPhoto.imageCached = YES;
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
}

- (void)dismissViewControllerWithSavedPhotos:(NSArray *)savedPhotos
{
    self.parsedPhotos = savedPhotos;
    if (delegate && [delegate respondsToSelector:@selector(didFinishLoadingData:)])
        [delegate didFinishLoadingData:self];
}

- (void)parseResult:(NSData *)data
{
	NSArray *savedPhotos = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedPhotosFilePath]];

	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *result = [jsonParser objectWithData:data];
	NSArray *photos  = [result objectForKey:@"data"];
	[jsonParser release];

	if ([photos count] == [savedPhotos count])
	{
		progressBar.progress = 1.0;
		[self dismissViewControllerWithSavedPhotos:savedPhotos];
		return;
	}

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

	[self downloadImages];

	NSString *savedPhotosFilePath = [self savedPhotosFilePath];
	[NSKeyedArchiver archiveRootObject:parsedPhotos toFile:savedPhotosFilePath];

	NSLog(@"Number of empty photo: %d", count);
	NSLog(@"Done");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	NSString *requestURL = [NSString stringByEscapingString:@"https://graph.facebook.com/fql?q=select caption, src_big from photo where aid ='108425012571651_29383'"];
	NSString *queryString = @"https://graph.facebook.com/fql?q=select pid, src_big from photo where aid =\"108425012571651_29383\" order by created desc";

	[AsyncURLConnection request:[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completeBlock:^void(NSData *data) {
		NSLog(@"Finished loading.");
		progressBar.progress = kJSONDataProgress;
		[self parseResult:data];
	} errorBlock:^void(NSError *error) {
		NSArray *savedPhotos = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedPhotosFilePath]];
		if (savedPhotos && [savedPhotos count])
		{
			progressBar.progress = 1.0;
			self.parsedPhotos = savedPhotos;
			if (delegate && [delegate respondsToSelector:@selector(didFinishLoadingData:)])
			{
                [self performSelector:@selector(dismissViewControllerWithSavedPhotos:) withObject:savedPhotos afterDelay:0.5];
//				[self.view removeFromSuperview];
			}
			return;
		}
		else
		{
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot download images. Please check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alertView show];
		}
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
