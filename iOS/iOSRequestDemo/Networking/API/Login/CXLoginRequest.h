//
//  CXLoginRequest.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import "CXRequest.h"
#import "CXLoginRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXLoginRequest : CXRequest

@property (nonatomic, strong) CXLoginRequestModel *parameterModel;

- (instancetype)initWithModel:(CXLoginRequestModel *)model;

@end

NS_ASSUME_NONNULL_END
