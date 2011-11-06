//
//  LoadingViewController.h
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



@interface LoadingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;

- (void)parseResult:(NSData *)data;
@end
