#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface Person : NSObject
- (void)read;
- (void)run;
+ (void)eat;
@end
@implementation Person
- (void)read {
    NSLog(@"person read, self: %@", self);
}
- (void)run {
    NSLog(@"person run, self: %@", self);
}
+ (void)eat {
    NSLog(@"eat, self: %@", self);
}
@end

void _hook_read(id self, SEL _cmd) {
    NSLog(@"hook read, self: %@", self);
}

static void _hook_get_class(Class class, Class statedClass) {
    Method method = class_getInstanceMethod(class, @selector(class));
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return statedClass;
    });
    class_replaceMethod(class, @selector(class), newIMP, method_getTypeEncoding(method));
}

void simulate_instance_aspect()
{
    Person *p = [[Person alloc] init];
    Class baseClass = object_getClass(p); // 获取当前对象p的isa指针
    Class statedClass = p.class;
    
    const char *subclassName = "Aspect_subClass";
    // 创建子类
    Class subclass = objc_allocateClassPair(baseClass, subclassName, 0);
    // 子类的isa指针指向父类
    _hook_get_class(subclass, statedClass);
    // 子类的元类的isa指针指向父类
    _hook_get_class(object_getClass(subclass), statedClass);
    // 注册子类
    objc_registerClassPair(subclass);
    // 把父类对象p的isa指针指向子类
    object_setClass(p, subclass);
    
    // hook子类的read方法
    Method m = class_getInstanceMethod(subclass, @selector(read));
    method_setImplementation(m, (IMP)_hook_read);
    
    // 父类的方法被调用时，实际上被转发到子类, 子类的方法实现又被指向了 _hook_read 函数
    SEL selector = NSSelectorFromString(@"read");
#pragma clang diagnostic push
#pragma clang diagnostic ignored   "-Warc-performSelector-leaks"
    if ([p respondsToSelector:selector]) {
        [p performSelector:selector]; // 子类执行父类的read方法
    }
    
    // run方法没有被hook，还是走父类的实现
    if ([p respondsToSelector:@selector(run)]) {
        [p run];
    }
#pragma clang diagnostic pop
}


static void test_forward_invocation(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    NSLog(@"hook forwardInvocation: self: %@", self);    
    // 调用原方法
    SEL aliasSelector = NSSelectorFromString(@"aspect_test");
    [invocation setSelector:aliasSelector];
    [invocation invoke];
}

void simulate_class_aspect(Class class, SEL selector)
{
    // 返回元类的isa指针
    Class cls = object_getClass(class);
    
    // 替换原方法的 forwardInvocation: 实现
    class_replaceMethod(cls, @selector(forwardInvocation:), (IMP)test_forward_invocation, "v@:@");

    // 生成一个aliasSelctor指向原方法的实现
    Method targetMethod = class_getInstanceMethod(cls, selector);
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    SEL aliasSelector = NSSelectorFromString(@"aspect_test");
    class_addMethod(cls, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
    
    // 让原方法之间强制走转发流程
    class_replaceMethod(cls, selector, (IMP)_objc_msgForward, typeEncoding);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // hook 实例方法
        simulate_instance_aspect();
        
        // hook 类方法
        simulate_class_aspect(Person.class, @selector(eat));
        [Person eat];
    }
    return 0;
}
