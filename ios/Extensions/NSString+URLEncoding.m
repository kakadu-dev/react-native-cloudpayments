//
//  NSString+URLEncoding.m
//
//  Created by Dmitry Sytsevich on 5/30/19.
//  Copyright © 2019 Dmitry Sytsevich. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)stringByURLEncoding {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (CFStringRef)self,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'\"();:@+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end {
    NSScanner* scanner = [NSScanner scannerWithString:(__bridge NSString * _Nonnull)((__bridge CFStringRef)self)];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:nil];
    if ([scanner scanString:start intoString:nil])
    {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result])
        {
            return result;
        }
    }
    return nil;
}

@end
