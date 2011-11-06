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
@implementation LoadingViewController
@synthesize loadingLabel;
@synthesize progressBar;

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
	NSMutableArray *parsedPhotos = [[NSMutableArray alloc] initWithCapacity:[photos count]];

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
		progressBar.progress = 0.2;
		[self parseResult:data];
	} errorBlock:^void(NSError *error) {
		NSLog(@"Error: %@", [error description]);
	}];
}

- (void)viewDidUnload
{
    [self setLoadingLabel:nil];
    [self setProgressBar:nil];
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
    [loadingLabel release];
    [progressBar release];
    [super dealloc];
}
@end
