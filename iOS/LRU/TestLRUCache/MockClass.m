//
//  MockClass.m
//  TestLRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "MockClass.h"

@implementation MockClass

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    _name = name;
    return self;
}

- (void)dealloc {
    NSLog(@"mock dealloc. %@", self.name);
}
@end
