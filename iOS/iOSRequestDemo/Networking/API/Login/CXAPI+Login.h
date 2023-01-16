//
//  CXAPI+Login.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import "CXAPI.h"
#import "CXLoginRequest.h"
#import "CXLoginResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXAPI (Login)

- (void)login:(CXLoginRequestModel *)model completion:(void (^)(NSError * _Nullable error, CXLoginResponseModel * _Nullable response))completion;

@end

NS_ASSUME_NONNULL_END
