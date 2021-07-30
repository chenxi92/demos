#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSArray *perferences;
@end

NS_ASSUME_NONNULL_END
