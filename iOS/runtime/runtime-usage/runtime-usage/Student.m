#import "Student.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Student

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    if (propertys) free(propertys);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count;
        objc_property_t *propertys = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = propertys[i];
            const char *name = property_getName(property);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        if (propertys) free(propertys);
    }
    return self;
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"\n{"];
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [desc appendFormat:@"\n%@: %@",key, value];
    }
    if (propertys) free(propertys);
    [desc appendFormat:@"\n}"];
    return [desc copy];
}
@end
