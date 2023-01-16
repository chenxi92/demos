//
//  CXLoginRequestModel.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import "CXRequestModelDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXLoginRequestModel : NSObject <CXRequestModelDelegate>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
