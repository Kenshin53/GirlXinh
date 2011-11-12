//
//  Created by caomanhtuanbsb on 10/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol PhotoParserDelegate <NSObject>

-(void) didFinishParsingPhotos:(NSArray *) parsedPhotos;
-(void) didFailParsingPhotos:(NSError *) error;

@end

@interface PhotoParser : NSObject
{
    id <PhotoParserDelegate> delegate;
}

@property (nonatomic, assign) id <PhotoParserDelegate> delegate;

+ (NSString *) savedPhotosFilePath;

- (NSArray *) parseFacebookPhoto;
+ (NSArray *) savedPhotos;
+ (NSArray *) downloadedPhotos;
@end