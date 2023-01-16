//
//  CXLoginRequest.m
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import "CXLoginRequest.h"
#import "CXRequestJsonParameterEncryptAdapter.h"
#import "CXResponseDecryptAdapter.h"

@implementation CXLoginRequest

- (instancetype)initWithModel:(CXLoginRequestModel *)model {
    if (self = [super init]) {
        _parameterModel = model;
        [self config];
    }
    return self;
}

- (void)config {
    self.baseURLString = @"https://host.com/login";
    self.path = @"v1/visitor";
    self.method = CXHTTPMethodPOST;
    self.contentType = CXContentTypeJson;
    
    CXRequestJsonParameterEncryptAdapter *adapter = [CXRequestJsonParameterEncryptAdapter new];
    adapter.encryptBlock = ^NSDictionary * _Nonnull(NSDictionary * _Nonnull parameter) {
        return parameter;
    };
    [self addRequestAdapter:adapter];
    
    CXResponseDecryptAdapter *responseAdapter = [CXResponseDecryptAdapter new];
    responseAdapter.decryptBlock = ^NSDictionary * _Nonnull(NSDictionary * _Nonnull response) {
        return response;
    };
    self.responseAdapter = responseAdapter;
}

- (NSDictionary *)parameters {
    return [self.parameterModel toDictionary];
}

@end
