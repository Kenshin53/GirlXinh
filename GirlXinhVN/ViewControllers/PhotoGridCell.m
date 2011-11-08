//
//  Created by caomanhtuanbsb on 07/11/2011.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhotoGridCell.h"


@implementation PhotoGridCell 

@synthesize imageView;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) 
    {
        identifier = [[NSString stringWithString:@"photoGridCellId"] retain];
    }
    
    return self;
}

- (void)dealloc 
{
    [identifier release];
    [imageView release];
    [super dealloc];
}
@end