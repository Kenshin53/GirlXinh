//
//  LoadingViewController.h
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



#import "EGOImageLoader.h"
#import "PhotoParser.h"
@class  LoadingViewController;


@protocol LoadingViewDelegate <NSObject>

-(void) didFinishLoadingData:(LoadingViewController *)viewController;
-(void) didFailLoadingData:(LoadingViewController *) viewController;

@end

@interface LoadingViewController : UIViewController <EGOImageLoaderObserver, PhotoParserDelegate >
{

    id <LoadingViewDelegate> delegate;
	PhotoParser *photoParser;
	NSMutableArray *downloadedPhotos;
	NSTimer *updateTimer;
	NSUInteger index;
	NSInteger totalImageToDownload;
	NSInteger numberOfDownloadedImage;

}
@property (assign, nonatomic) id <LoadingViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@property (retain, nonatomic) IBOutlet UIImageView *coverImage;

@end
