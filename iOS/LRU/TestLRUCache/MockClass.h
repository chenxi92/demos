//
//  MockClass.h
//  TestLRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MockClass : NSObject

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
