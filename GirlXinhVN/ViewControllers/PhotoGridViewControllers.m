//
//  PhotoGridViewControllers.m
//  GirlXinhVN
//
//  Created by Manh Tuan Cao on 11/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoGridViewControllers.h"
#import "PhotoGridCell.h"
#import "EGOCache.h"
#import "Photo.h"
#import "MWPhotoBrowser.h"

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
	[loadingViewController release];
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
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
	loadingViewController.delegate = self;
	[self.navigationController presentModalViewController:loadingViewController animated:YES];
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

	[self.navigationController dismissModalViewControllerAnimated:YES];
	photos = [[PhotoParser downloadedPhotos] mutableCopy];
	[self.gridView reloadData];

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
    NSInteger numberOfRow  = [self.photos count] / 3;
    NSInteger extraRow = [self.photos count] % 3 == 0 ? 0 : 1;
	return numberOfRow + extraRow;
    
//    return 50;
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index;
{
    if ([self.photos count] % 3 != 0) 
        return (index < [self.photos count] / 3) ? 3 : [self.photos count] %3 + 1; 
	return 3;

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex;
{

	return 106.0;

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
{
	return 106.0;
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
    
    NSURL *aURL = [NSURL URLWithString:[[photos objectAtIndex:rowIndex * 3 + columnIndex] bigPhotoURL]];
    cell.imageView.image = [[EGOCache currentCache] imageForKey:keyForURL(aURL,@"thumbnail")];

	return cell;

	
}

- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
{
	NSMutableArray *mwPhotos = [[NSMutableArray alloc] init];
    for (Photo *aPhoto in self.photos) 
    {
        NSURL *aURL = [NSURL URLWithString:aPhoto.bigPhotoURL];
        [mwPhotos addObject:[MWPhoto photoWithFilePath:cachePathForKey(keyForURL(aURL, nil))]];
    }

	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:mwPhotos];
	[browser setInitialPageIndex:rowIndex * 3 + columnIndex]; // Can be changed if desired
	[self.navigationController pushViewController:browser animated:YES];
	[browser release];
	[mwPhotos release];

}


@end
