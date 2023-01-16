//
//  CXAPI+Login.m
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import "CXAPI+Login.h"
#import "CXSession.h"

@implementation CXAPI (Login)

- (void)login:(CXLoginRequestModel *)model completion:(void (^)(NSError * _Nullable, CXLoginResponseModel * _Nullable))completion {
    CXLoginRequest *request = [[CXLoginRequest alloc] initWithModel:model];
    [CXSession.sharedInstance send:request completion:^(NSError * _Nullable error, NSDictionary * _Nullable response) {
        if (error) {
            completion(error, nil);
        } else {
            completion(nil, [CXLoginResponseModel parse:response]);
        }
    }];
}


@end
