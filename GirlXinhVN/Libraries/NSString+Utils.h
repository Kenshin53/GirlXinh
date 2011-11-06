//
//  NSString+Utils.h
//  PocketTropes
//
//  Created by Anh Quang Do on 16/04/2011.
//  Copyright 2011 Anh Quang Do. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Utils)

- (NSString *)unCamelCaseString;
- (NSString *)camelCaseString;

+ (NSString *)stringByEscapingString:(NSString *)text;

@end
