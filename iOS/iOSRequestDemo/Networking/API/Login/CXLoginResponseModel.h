//
//  CXLoginResponseModel.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import "CXResponseModelDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXLoginResponseModel : NSObject <CXResponseModelDelegate>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *roleId;

@end

NS_ASSUME_NONNULL_END
