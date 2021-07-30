#import <Foundation/Foundation.h>
#import "Test.h"

#pragma mark - Test Case

void test_method_forward()
{
    Test *t = [Test new];
    [t instancePrint:@"instance"];
    
    [Test classPrint:@"class"];
}

void test_forward_target()
{
    Test *t = [Test new];
    [t run];
}

void test_invoke()
{
    Test *t = [Test new];
    [t read];
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        test_method_forward();
        test_forward_target();
        test_invoke();
    }
    return 0;
}
