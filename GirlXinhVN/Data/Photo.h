//
//  Created by caomanhtuanbsb on 06/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Photo : NSObject <NSCoding>
{
	NSString *photoID;
	NSString *bigPhotoURL;

}
@property(nonatomic, retain) NSString *photoID;
@property(nonatomic, retain) NSString *bigPhotoURL;

@end