//
//  NSArray+Swizzling.m
//  usage
//
//  Created by 陈希 on 2020/4/18.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzling)

+ (void)load {
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod   = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(cx_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)cx_objectAtIndex:(NSUInteger)index {
    if (self.count - 1 < index) {
        @try {
            return [self cx_objectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
        }
    } else {
        return [self cx_objectAtIndex:index];
    }
}
@end
