//
//  NSString+URL.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URL)

- (NSString *)cx_urlEncode;

- (NSString *)cx_urlDecode;

@end

NS_ASSUME_NONNULL_END
