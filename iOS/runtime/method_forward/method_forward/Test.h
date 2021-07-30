#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Test : NSObject
// The following method was not implement
+ (void)classPrint:(NSString *)text;
- (void)instancePrint:(NSString *)text;
- (void)run;
- (void)read;
@end

@interface Person : NSObject
- (void)run;
@end

@interface Student : NSObject
- (void)read;
@end

NS_ASSUME_NONNULL_END
