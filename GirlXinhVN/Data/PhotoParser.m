//
//  Created by caomanhtuanbsb on 10/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhotoParser.h"
#import "AsyncURLConnection.h"
#import "SBJson.h"
#import "Photo.h"
#import "EGOCache.h"
#import "EGOImageLoader.h"
@implementation PhotoParser {

}

@synthesize delegate;

+ (NSString *)savedPhotosFilePath
{
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentRootPath = [documentPaths objectAtIndex:0];
	NSString *savedPhotosFilePath = [documentRootPath stringByAppendingString:@"savedPhotos.plist"];
	return savedPhotosFilePath;
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
+(NSArray *)savedPhotos
{
    return 	[NSKeyedUnarchiver unarchiveObjectWithFile:[PhotoParser savedPhotosFilePath]];
}

+(NSArray *) downloadedPhotos
{
	NSMutableArray *arrayToDeleted = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    NSArray *photos = [PhotoParser savedPhotos];
    
	for(Photo *aPhoto in photos)
	{        
		NSURL *aURl = [NSURL URLWithString:aPhoto.bigPhotoURL];
		aPhoto.imageCached = [[EGOCache currentCache] hasCacheForKey:keyForURL(aURl, nil)];
		aPhoto.thumbnailCached = [[EGOCache currentCache] hasCacheForKey:keyForURL(aURl, @"thumbnail")];
		if ( ! aPhoto.imageCached )
			[arrayToDeleted addObject:aPhoto];
	}
    
    NSMutableArray *tempPhotos = [[photos mutableCopy] autorelease];
    [tempPhotos removeObjectsInArray:arrayToDeleted];
    
	return tempPhotos;
}


// ***********************************************************************************
//
//
//
// ***********************************************************************************

- (void)parseResult:(NSData *)data
{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.imageCached==YES"];
//    NSArray *savedPhotos = [NSKeyedUnarchiver unarchiveObjectWithFile:[PhotoParser savedPhotosFilePath]];
//    NSArray *downloadedPhotos = [savedPhotos filteredArrayUsingPredicate:predicate];   
    NSArray *downloadedPhotos = [PhotoParser downloadedPhotos];
    
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	NSDictionary *result = [jsonParser objectWithData:data];
	NSArray *photos  = [result objectForKey:@"data"];
	[jsonParser release];
    
	if ([photos count] == [downloadedPhotos count])
	{
        if (delegate && [delegate respondsToSelector:@selector(didFinishParsingPhotos:)]) 
            [delegate performSelector:@selector(didFinishParsingPhotos:) withObject:downloadedPhotos];
        
		return;
	}
    
	NSMutableArray *parsedPhotos = [[[NSMutableArray alloc] initWithCapacity:[photos count]] autorelease];

	for(NSDictionary *aPhotoDict in photos)
	{
		Photo *aPhoto = [[Photo alloc] init];
		aPhoto.photoID = [aPhotoDict objectForKey:@"pid"];
		aPhoto.bigPhotoURL = [aPhotoDict objectForKey:@"src_big"];
		[parsedPhotos addObject:aPhoto];
		[aPhoto release];
	}
    
	[NSKeyedArchiver archiveRootObject:parsedPhotos toFile:[PhotoParser savedPhotosFilePath]];

    if (delegate && [delegate respondsToSelector:@selector(didFinishParsingPhotos:)]) 
        [delegate performSelector:@selector(didFinishParsingPhotos:) withObject:parsedPhotos];

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
- (NSArray *)parseFacebookPhoto
{
	
    NSString *queryString = @"https://graph.facebook.com/fql?q=select pid, src_big from photo where aid =\"108425012571651_29383\" order by created desc";
	
    NSString *escapedQueryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
    
    [AsyncURLConnection request:escapedQueryString
                  completeBlock:^void(NSData *data) 
    {
		[self parseResult:data];
	}
                     errorBlock:^void(NSError *error) 
    {
        if (delegate && [delegate respondsToSelector:@selector(didFailParsingPhotos:)])
            [delegate performSelector:@selector(didFailParsingPhotos:) withObject:error];
        
	}];
	return nil;

}


// ***********************************************************************************
//
//
//
// ***********************************************************************************
@end