#import <Foundation/Foundation.h>
#import "NSArray+Swizzling.h"
#import "NSObject+Swizzling.h"
#import "NSObject+Model.h"
#import "Student.h"
#import "Modle.h"

@interface Person : NSObject
@end
@implementation Person
@end


void test_array_crash()
{
    NSArray *array = @[@"first", @"two"];
    NSLog(@"%@", [array objectAtIndex:3]);
}

void test_associate()
{
    Person *p = [[Person alloc] init];
    p.associatedObject = @"this is a test.";
    NSLog(@"%@", p.associatedObject);
}

void test_encode_and_decode()
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"test_student"];
    
    Student *s = [[Student alloc] init];
    s.name = @"chenxi";
    s.age = 27;
    s.address = @"Beijing";
    s.perferences = @[@"basketbass", @"football"];
    NSLog(@"archive: %@", s.description);
    BOOL success = [NSKeyedArchiver archiveRootObject:s toFile:filePath];
    if (success == NO) {
        NSLog(@"archive fail.");
    } else {
        Student *two = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (two) {
            NSLog(@"unarchive: %@", two.description);
            NSLog(@"%@", filePath);
        }
    }
}

void test_mode_convert()
{
    NSDictionary *dic = @{
        @"name": @"chenxi",
        @"preference": @[
            @"first"
        ],
        @"model": @{
            @"key": @"value"
        },
        @"age": @12,
        @"price": @(1.2),
        @"success": @(YES)
    };
    Modle *p = [[Modle alloc] cx_initWithDictionary:dic];
    NSLog(@"%@", [p cx_jsonWithObject]);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        test_array_crash();
//        test_associate();
//        test_encode_and_decode();
        test_mode_convert();
    }
    return 0;
}
