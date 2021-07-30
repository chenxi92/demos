//
//  LRUCache.h
//  LRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CXLRUCache : NSObject

- (instancetype)initWithCapacity:(int)capacity;

- (id)get:(id)key;

// cache will reference the value.
- (void)put:(id)key value:(id)value;

- (NSArray *)allValues;

@end

NS_ASSUME_NONNULL_END
