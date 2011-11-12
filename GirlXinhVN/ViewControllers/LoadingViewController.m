//
//  LoadingViewController.m
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingViewController.h"
#import "Photo.h"
#import "EGOImageLoader.h"
#import "EGOCache.h"
#define kJSONDataProgress 0.0

@implementation LoadingViewController
@synthesize loadingLabel;
@synthesize progressBar;
@synthesize coverImage;
@synthesize delegate;

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

// TODO: Handle broken download.

- (void)viewDidLoad
{
    [super viewDidLoad];
	numberOfDownloadedImage = 0;
	photoParser = [[PhotoParser alloc] init];
	photoParser.delegate = self;
	[photoParser parseFacebookPhoto];
}

- (void)updateUI
{
	if (index < [downloadedPhotos count])
	{
		UIImageView *imageView = (UIImageView *)[self.view viewWithTag:(index % 9) + 1];
		NSURL *aURL = [NSURL URLWithString:[[downloadedPhotos objectAtIndex:index] bigPhotoURL]];
		UIImage *thumbnailImage = [[EGOCache currentCache] imageForKey:keyForURL(aURL, @"thumbnail")];
		imageView.image = thumbnailImage;
		progressBar.progress = (float) numberOfDownloadedImage / totalImageToDownload;
		index ++;
	}
}

- (void)didFinishParsingPhotos:(NSArray *)parsedPhotos
{
	NSSet *downloadedPhotosSet = [NSSet setWithArray:[PhotoParser downloadedPhotos]];
	NSMutableSet *photosToDownloadSet =[NSMutableSet setWithArray:parsedPhotos];
	[photosToDownloadSet minusSet:downloadedPhotosSet];

	NSArray *photosToDownload = [photosToDownloadSet allObjects];
	
	totalImageToDownload = [photosToDownload count];
	if ( totalImageToDownload == 0)
	{
        if (delegate && [delegate respondsToSelector:@selector(didFinishLoadingData:)])
        {
            
            [delegate didFinishLoadingData:self];
        }
		return;
	}

	downloadedPhotos = [[NSMutableArray alloc] initWithCapacity:0];
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
	                                               target:self
	                                             selector:@selector(updateUI)
			                                     userInfo:nil
					                              repeats:YES];

	for (Photo *aPhoto in photosToDownload)
    {
        [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:aPhoto.bigPhotoURL]
                                                 completion:^void(UIImage *image, NSURL *imageURL, NSError *error)
         {
	         numberOfDownloadedImage++;
	         [downloadedPhotos addObject:aPhoto];
	         if ([downloadedPhotos count] == [photosToDownload count])
	         {
		         if (delegate && [delegate respondsToSelector:@selector(didFinishLoadingData:)])
		         {
			         [downloadedPhotos release];
                     [updateTimer invalidate];
                     updateTimer = nil;
			         [delegate didFinishLoadingData:self];
		         }
	         }
         }];
    }
}

- (void)didFailParsingPhotos:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(didFailLoadingData:)])
    {
        [delegate didFailLoadingData:self];
    }
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

    [photoParser release];
    [loadingLabel release];
    [progressBar release];
    [coverImage release];
    [super dealloc];
}



@end
