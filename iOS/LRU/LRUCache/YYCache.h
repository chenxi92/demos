//
//  YYCache.h
//  LRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYCache : NSObject

- (instancetype)initWithCapatity:(int)capatity;

- (BOOL)contailsObjectForKey:(id)key;
- (id)objectForKey:(id)key;

- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;
- (NSArray *)allObjects;
@end

NS_ASSUME_NONNULL_END
