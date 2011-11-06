//
//  NSString+Utils.m
//  PocketTropes
//
//  Created by Anh Quang Do on 16/04/2011.
//  Copyright 2011 Anh Quang Do. All rights reserved.
//

#import "NSString+Utils.h"


@implementation NSString (Utils)

- (NSString *)unCamelCaseString {
    NSError             *error     = nil;
    NSMutableString     *retVal    = [[self mutableCopy] autorelease];
    NSRegularExpression *firstPass = [NSRegularExpression regularExpressionWithPattern:@"([0-9A-Z]+|[A-Z][a-z])"
                                                                               options:0
                                                                                 error:&error];
    [firstPass replaceMatchesInString:retVal
                              options:0
                                range:NSMakeRange(0, [retVal length])
                         withTemplate:@" $0"];

    NSRegularExpression *secondPass = [NSRegularExpression regularExpressionWithPattern:@"[A-Z][a-z]+"
                                                                                options:0
                                                                                  error:&error];
    [secondPass replaceMatchesInString:retVal
                               options:0
                                 range:NSMakeRange(0, [retVal length])
                          withTemplate:@" $0"];

    NSRegularExpression *thirdPass = [NSRegularExpression regularExpressionWithPattern:@"\\s+"
                                                                               options:0
                                                                                 error:&error];
    [thirdPass replaceMatchesInString:retVal
                              options:0
                                range:NSMakeRange(0, [retVal length])
                         withTemplate:@" "];

    return [retVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// Not technically correct, but works in our specific case
- (NSString *)camelCaseString {
    NSString *retVal = [self stringByReplacingOccurrencesOfString:@"%20" withString:@""];
    retVal = [retVal stringByReplacingOccurrencesOfString:@" " withString:@""];

    return retVal;
}

+ (NSString *)stringByEscapingString:(NSString *)text {
    // http://stackoverflow.com/questions/705448/iphone-sdk-problem-with-ampersand-in-the-url-string
    NSMutableString *escaped = [[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSRange wholeString = [escaped rangeOfString:escaped];

    [escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:wholeString];
    [escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:wholeString];

    return [escaped autorelease];
}

@end
