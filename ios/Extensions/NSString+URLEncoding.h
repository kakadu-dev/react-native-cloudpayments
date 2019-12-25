//
//  NSString+URLEncoding.h
//
//  Created by Dmitry Sytsevich on 5/30/19.
//  Copyright © 2019 Dmitry Sytsevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)stringByURLEncoding;
- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end;

@end
