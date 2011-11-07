//
//  LoadingViewController.h
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



#import "EGOImageLoader.h"

@interface LoadingViewController : UIViewController <EGOImageLoaderObserver>
{
	float delta;

}
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@property (retain, nonatomic) IBOutlet UIImageView *coverImage;

- (void)parseResult:(NSData *)data;
@end
