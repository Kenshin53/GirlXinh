//
//  PhotoGridViewControllers.m
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoGridViewControllers.h"
#import "PhotoGridCell.h"
#import "LoadingViewController.h"
#import "EGOCache.h"
#import "Photo.h"

inline static NSString* keyForURL(NSURL* url, NSString* style) {
	if(style) {
		return [NSString stringWithFormat:@"EGOImageLoader-%u-%u", [[url description] hash], [style hash]];
	} else {
		return [NSString stringWithFormat:@"EGOImageLoader-%u", [[url description] hash]];
	}
}


@implementation PhotoGridViewControllers
@synthesize gridView =_gridView;
@synthesize photos;
// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (void)dealloc
{
    [photos release];
    [_gridView release];
    [super dealloc];
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loadingViewController= [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    loadingViewController.delegate = self;
    [self presentModalViewController:loadingViewController animated:YES];
    // Do any additional setup after loading the view from its nib.
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (void)viewDidUnload
{
    [self setGridView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
-(void)didFinishLoadingData:(LoadingViewController *)viewController
{
    self.photos = viewController.parsedPhotos;
    [self dismissModalViewControllerAnimated:YES];
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
-(void)didFailLoadingData:(LoadingViewController *)viewController
{
    
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView;
{
	return 5;

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index;
{
	return 4;

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex;
{

	return 80.0;

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
{
	return 80.0;
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (DTGridViewCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
{
    
    static NSString *episodeCellId = @"photoGridCellId";
	
	PhotoGridCell *cell = (PhotoGridCell *)[gridView dequeueReusableCellWithIdentifier:episodeCellId];
	if (cell == nil) {
		NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"PhotoGridCell" owner:self options:nil];
		for(id item in items) {
			if ([item isKindOfClass:[PhotoGridCell class]]) {
				cell = item;
				cell.identifier = episodeCellId;
				break;
			}
		}
		
	}
    
    NSURL *aURL = [NSURL URLWithString:[[photos objectAtIndex:rowIndex * 4 + columnIndex] bigPhotoURL]];
    UIImage* anImage = [[EGOCache currentCache] imageForKey:keyForURL(aURL,nil)];
    cell.imageView.image = anImage;
	return cell;


}

@end
