//
//  Created by caomanhtuanbsb on 06/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Photo : NSObject <NSCoding>
{
	NSString    *photoID;
	NSString    *bigPhotoURL;
	BOOL        imageCached;
	BOOL        thumbnailCached;

}

@property(nonatomic, retain) NSString *photoID;
@property(nonatomic, retain) NSString *bigPhotoURL;
@property(nonatomic) BOOL imageCached;
@property(nonatomic) BOOL thumbnailCached;


@end