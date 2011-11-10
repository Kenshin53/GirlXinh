//
//  Created by caomanhtuanbsb on 06/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Photo.h"


@implementation Photo {

}
@synthesize photoID;
@synthesize bigPhotoURL;
@synthesize imageCached;
@synthesize thumbnailCached;




//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.photoID forKey:@"photoID"];
    [encoder encodeObject:self.bigPhotoURL forKey:@"bigPhotoURL"];
    [encoder encodeBool:self.imageCached forKey:@"imageCached"];
    [encoder encodeBool:self.thumbnailCached forKey:@"thumbnailCached"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.photoID = [decoder decodeObjectForKey:@"photoID"];
        self.bigPhotoURL = [decoder decodeObjectForKey:@"bigPhotoURL"];
        self.imageCached = [decoder decodeBoolForKey:@"imageCached"];
        self.thumbnailCached = [decoder decodeBoolForKey:@"thumbnailCached"];
    }
    return self;
}

- (void)dealloc {
	[photoID release];
	[bigPhotoURL release];
	[super dealloc];

}
@end