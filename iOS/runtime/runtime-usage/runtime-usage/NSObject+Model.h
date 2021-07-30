#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Model)

- (id)cx_initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)cx_jsonWithObject;

@end

NS_ASSUME_NONNULL_END
