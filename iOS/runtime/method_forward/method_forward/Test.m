#import "Test.h"
#import <objc/runtime.h>

void instance_print(id self, SEL _cmd, NSString *text)
{
    NSLog(@"replaced method %@", text);
}

void class_print(id self, SEL _cmd, NSString *text)
{
    NSLog(@"replaced class method %@", text);
}

@implementation Test

+ (BOOL)resolveClassMethod:(SEL)sel {
    SEL normalSelector = NSSelectorFromString(@"classPrint:");
    if (sel == normalSelector) {
        // 类方法列表在元类中查找
        class_addMethod(object_getClass(self), sel, (IMP)class_print, "v@:@");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    SEL normalSelector = NSSelectorFromString(@"instancePrint:");
    if (sel == normalSelector) {
        class_addMethod([self class], normalSelector, (IMP)instance_print, "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    SEL normalSelector = NSSelectorFromString(@"run");
    if (aSelector == normalSelector) {
        return [[Person alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    SEL normalSelector = NSSelectorFromString(@"read");
    if (aSelector == normalSelector) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL normalSelector = NSSelectorFromString(@"read");
    if (anInvocation.selector == normalSelector) {
        Student *s = [Student new];
        [anInvocation invokeWithTarget:s];
    } else {
        [super forwardInvocation:anInvocation];
    }
}
@end

@implementation Person
- (void)run {
    NSLog(@"%@ run", [self class]);
}
@end

@implementation Student
- (void)read {
    NSLog(@"%@ read, %p", [self class], self);
}
- (void)dealloc {
    NSLog(@"dealloc %p", self);
}
@end
