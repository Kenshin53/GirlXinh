//
//  PhotoGridViewControllers.h
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DTGridView.h"
#import "LoadingViewController.h"

@interface PhotoGridViewControllers : UIViewController  <DTGridViewDelegate, DTGridViewDataSource, LoadingViewDelegate>
{
    LoadingViewController *loadingViewController;
    NSMutableArray *photos;
    
}
@property (retain, nonatomic) NSMutableArray *photos;
@property (retain, nonatomic) IBOutlet DTGridView *gridView;

@end
