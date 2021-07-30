#import "NSObject+Model.h"
#import <objc/runtime.h>
#import <objc/message.h>

typedef NS_ENUM(NSUInteger, CXEncodingType) {
    CXEncodingTypeUnknown    = 0, ///< unknown
    CXEncodingTypeVoid       = 1, ///< void
    CXEncodingTypeBool       = 2, ///< bool
    CXEncodingTypeInt8       = 3, ///< char / BOOL
    CXEncodingTypeUInt8      = 4, ///< unsigned char
    CXEncodingTypeInt16      = 5, ///< short
    CXEncodingTypeUInt16     = 6, ///< unsigned short
    CXEncodingTypeInt32      = 7, ///< int
    CXEncodingTypeUInt32     = 8, ///< unsigned int
    CXEncodingTypeInt64      = 9, ///< long long
    CXEncodingTypeUInt64     = 10, ///< unsigned long long
    CXEncodingTypeFloat      = 11, ///< float
    CXEncodingTypeDouble     = 12, ///< double
    CXEncodingTypeLongDouble = 13, ///< long double
    CXEncodingTypeObject     = 14, ///< id
    CXEncodingTypeClass      = 15, ///< Class
    CXEncodingTypeSEL        = 16, ///< SEL
    CXEncodingTypeBlock      = 17, ///< block
    CXEncodingTypePointer    = 18, ///< void*
    CXEncodingTypeStruct     = 19, ///< struct
    CXEncodingTypeUnion      = 20, ///< union
    CXEncodingTypeCString    = 21, ///< char*
    CXEncodingTypeCArray     = 22, ///< char[10] (for example)
};

static inline CXEncodingType cx_propertyEncodingType(objc_property_t property)
{
    CXEncodingType type = 0;
    NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSArray *attributeArray = [attribute componentsSeparatedByString:@","];
    if (attributeArray == nil || attributeArray.count < 1) return type;
    
    NSString *firstValue = (NSString *)[attributeArray firstObject];
    NSString *value = [firstValue substringFromIndex:1];

    switch (*(value.UTF8String)) {
        case 'v': return CXEncodingTypeVoid;
        case 'B': return CXEncodingTypeBool;
        case 'c': return CXEncodingTypeInt8;
        case 'C': return CXEncodingTypeUInt8;
        case 's': return CXEncodingTypeInt16;
        case 'S': return CXEncodingTypeUInt16;
        case 'i': return CXEncodingTypeInt32;
        case 'I': return CXEncodingTypeUInt32;
        case 'l': return CXEncodingTypeInt32;
        case 'L': return CXEncodingTypeUInt32;
        case 'q': return CXEncodingTypeInt64;
        case 'Q': return CXEncodingTypeUInt64;
        case 'f': return CXEncodingTypeFloat;
        case 'd': return CXEncodingTypeDouble;
        case 'D': return CXEncodingTypeLongDouble;
        case '#': return CXEncodingTypeClass;
        case ':': return CXEncodingTypeSEL;
        case '*': return CXEncodingTypeCString;
        case '^': return CXEncodingTypePointer;
        case '[': return CXEncodingTypeCArray;
        case '(': return CXEncodingTypeUnion;
        case '{': return CXEncodingTypeStruct;
        case '@': {
            if (value.length == 2 && [value isEqualToString:@"@?"]) {
                return CXEncodingTypeBlock;
            } else {
                return CXEncodingTypeObject;
            }
        }
        default: return CXEncodingTypeUnknown;
    }
}

static inline BOOL cx_isCNumber(CXEncodingType type)
{
    switch (type) {
        case CXEncodingTypeBool:
        case CXEncodingTypeInt8:
        case CXEncodingTypeUInt8:
        case CXEncodingTypeInt16:
        case CXEncodingTypeUInt16:
        case CXEncodingTypeInt32:
        case CXEncodingTypeUInt32:
        case CXEncodingTypeInt64:
        case CXEncodingTypeUInt64:
        case CXEncodingTypeFloat:
        case CXEncodingTypeDouble:
        case CXEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

static inline void cx_setNumberToProperty(CXEncodingType type, id self, SEL setSelector, NSNumber *value)
{
    switch (type) {
        case CXEncodingTypeBool:
            ((void (*)(id, SEL, bool))(void *) objc_msgSend)(self, setSelector, value.boolValue);
            break;
        case CXEncodingTypeInt8:
            ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)(self, setSelector, (int8_t)value.charValue);
            break;
        case CXEncodingTypeUInt8:
            ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)(self, setSelector, (uint8_t)value.unsignedCharValue);
            break;
        case CXEncodingTypeInt16:
            ((void (*)(id, SEL, int16_t))(void *) objc_msgSend)(self, setSelector, (int16_t)value.shortValue);
            break;
        case CXEncodingTypeUInt16:
            ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)(self, setSelector, (uint16_t)value.unsignedShortValue);
            break;
        case CXEncodingTypeInt32:
            ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)(self, setSelector, (int32_t)value.intValue);
            break;
        case CXEncodingTypeUInt32:
            ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)(self, setSelector, (uint32_t)value.unsignedIntValue);
            break;
        case CXEncodingTypeInt64:
            if ([value isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)(self, setSelector, (int64_t)value.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)(self, setSelector, (uint64_t)value.longLongValue);
            }
            break;
        case CXEncodingTypeUInt64:
            if ([value isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)(self, setSelector, (int64_t)value.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)(self, setSelector, (uint64_t)value.unsignedLongLongValue);
            }
            break;
        case CXEncodingTypeFloat:
            ((void (*)(id, SEL, float))(void *) objc_msgSend)(self, setSelector, value.floatValue);
            break;
        case CXEncodingTypeDouble:
            ((void (*)(id, SEL, float))(void *) objc_msgSend)(self, setSelector, value.doubleValue);
            break;
        case CXEncodingTypeLongDouble:
            ((void (*)(id, SEL, float))(void *) objc_msgSend)(self, setSelector, (long double)value.doubleValue);
            break;
        default:
            break;
    }
}

static inline NSNumber * cx_createNumberProperty(CXEncodingType type, id self, SEL getSelecter)
{
    switch (type) {
        case CXEncodingTypeBool:{
            return @(((bool (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeInt8: {
            return @(((int8_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeUInt8: {
            return @(((uint8_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeInt16: {
            return @(((int16_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeUInt16: {
            return @(((uint16_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeInt32: {
            return @(((int32_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeUInt32: {
            return @(((uint32_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeInt64: {
            return @(((int64_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeUInt64: {
            return @(((uint64_t (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter));
        }
        case CXEncodingTypeFloat: {
            float num = ((float (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }
        case CXEncodingTypeDouble: {
            double num = ((double (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }
        case CXEncodingTypeLongDouble: {
            double num = ((long double (*)(id, SEL))(void *) objc_msgSend)((id)self, getSelecter);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }
        default: return nil;
    }
}


@implementation NSObject (Model)

- (id)cx_initWithDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary) {
        id value = [dictionary objectForKey:key];
        objc_property_t property = class_getProperty(self.class, [key UTF8String]);
        if (!property) continue;
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *setSelectorName = [NSString stringWithFormat:@"set%@%@:", [name substringToIndex:1].uppercaseString, [name substringFromIndex:1]];
        SEL setSelector = NSSelectorFromString(setSelectorName);
        CXEncodingType type = cx_propertyEncodingType(property);
        if (cx_isCNumber(type)) {
            cx_setNumberToProperty(type, self, setSelector, value);
        } else {
            ((id (*)(id, SEL, id)) objc_msgSend)((id)self, setSelector, value);
        }
    }
    return self;
}


- (NSDictionary *)cx_jsonWithObject {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        SEL getSelector = NSSelectorFromString(name);
        CXEncodingType type = cx_propertyEncodingType(property);
        id value;
        if (cx_isCNumber(type)) {
            value = cx_createNumberProperty(type, self, getSelector);
        } else {
            value = ((id (*)(id, SEL))objc_msgSend)(self, getSelector);
        }
        if (value) [dic setObject:value forKey:name];
    }
    if (properties) free(properties);
    return [dic copy];
}




@end
