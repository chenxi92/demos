//
//  TestLRUCache.m
//  TestLRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CXLRUCache.h"
#import "MockClass.h"
#import "YYCache.h"

@interface TestLRUCache : XCTestCase

@end

@implementation TestLRUCache

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMockClass {
    MockClass *c1 = [[MockClass alloc] initWithName:@"name 1"];
    MockClass *c2 = [[MockClass alloc] initWithName:@"name 2"];
    MockClass *c3 = [[MockClass alloc] initWithName:@"name 3"];
    MockClass *c4 = [[MockClass alloc] initWithName:@"name 4"];
    MockClass *c5 = [[MockClass alloc] initWithName:@"name 5"];
    
    CXLRUCache *cache = [[CXLRUCache alloc] initWithCapacity:3];
    [cache put:@"1" value:c1];
    [cache put:@"2" value:c2];
    [cache put:@"3" value:c3];
    [cache put:@"4" value:c4];
    [cache put:@"5" value:c5];
    [cache get:@"4"];
    
    for (MockClass *c in [cache allValues]) {
        NSLog(@"-- %@", c.name);
    }
}

- (void)testNumber {
    CXLRUCache *cache = [[CXLRUCache alloc] initWithCapacity:4];
    [cache put:@(1) value:@(1)];
    [cache put:@(2) value:@(2)];
    [cache put:@(3) value:@(3)];
    [cache put:@(4) value:@(4)];
    [cache get:@(2)];
    [cache put:@(5) value:@(5)];
    [cache put:@(6) value:@(6)];
    
    for (NSNumber * n in [cache allValues]) {
        NSLog(@"%@", n);
    }
}

- (void)testYYCache {
    YYCache *cache = [[YYCache alloc] initWithCapatity:4];
    [cache setObject:@(1) forKey:@(1)];
    [cache setObject:@(2) forKey:@(2)];
    [cache setObject:@(3) forKey:@(3)];
    [cache setObject:@(4) forKey:@(4)];
    [cache setObject:@(5) forKey:@(5)];
    [cache setObject:@(6) forKey:@(6)];
    NSLog(@"get value: %@", [cache objectForKey:@(3)]);
    NSLog(@"get value: %@", [cache objectForKey:@(2)]);
    
    for (NSNumber * n in [cache allObjects]) {
        NSLog(@"%@", n);
    }
}

- (void)testClassYYCache {
    MockClass *c1 = [[MockClass alloc] initWithName:@"name 1"];
    MockClass *c2 = [[MockClass alloc] initWithName:@"name 2"];
    MockClass *c3 = [[MockClass alloc] initWithName:@"name 3"];
    MockClass *c4 = [[MockClass alloc] initWithName:@"name 4"];
    MockClass *c5 = [[MockClass alloc] initWithName:@"name 5"];
    
    YYCache *cache = [[YYCache alloc] initWithCapatity:3];
    [cache setObject:c1 forKey:@(1)];
    [cache setObject:c2 forKey:@(2)];
    [cache setObject:c3 forKey:@(3)];
    [cache setObject:c4 forKey:@(4)];
    [cache setObject:c5 forKey:@(5)];
    for (MockClass *c in [cache allObjects]) {
        NSLog(@"-- %@", c.name);
    }
    [cache setObject:c1 forKey:@(1)];
}
@end
