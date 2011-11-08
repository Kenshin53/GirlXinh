//
//  Created by caomanhtuanbsb on 08/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+Resize.h"


@implementation UIImage (Resize)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end