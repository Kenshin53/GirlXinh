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
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"

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
	return 250;

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
    cell.imageView.image = [[EGOCache currentCache] imageForKey:keyForURL(aURL,@"thumbnail")];

	return cell;

	
}

- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
{
//	Photo *aPhoto = [self.photos objectAtIndex:rowIndex * 4 + columnIndex];
//	PhotoViewerViewController *photoViewerViewController = [[PhotoViewerViewController alloc] initWithNibName:@"PhotoViewerViewController" bundle:nil];
//	photoViewerViewController.wantsFullScreenLayout = YES;
//	photoViewerViewController.photo = aPhoto;
//	[self.navigationController pushViewController:photoViewerViewController animated:YES];
//	[photoViewerViewController release];


    
	NSMutableArray *mwPhotos = [[NSMutableArray alloc] init];
    for (Photo *aPhoto in self.photos) 
    {
        NSURL *aURL = [NSURL URLWithString:aPhoto.bigPhotoURL];
        [mwPhotos addObject:[MWPhoto photoWithFilePath:cachePathForKey(keyForURL(aURL, nil))]];
    }

	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:mwPhotos];
	[browser setInitialPageIndex:rowIndex * 4 + columnIndex]; // Can be changed if desired
	[self.navigationController pushViewController:browser animated:YES];
	[browser release];
	[mwPhotos release];

}


@end
