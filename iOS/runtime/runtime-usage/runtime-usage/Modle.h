#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Modle : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *preference;
@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) BOOL success;

@end

NS_ASSUME_NONNULL_END
