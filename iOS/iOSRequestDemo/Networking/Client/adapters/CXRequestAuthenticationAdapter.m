//
//  CXRequestAuthenticationAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXRequestAuthenticationAdapter.h"
#import "CXRequest.h"

@interface CXRequestAuthenticationAdapter()

@property (nonatomic, copy, nullable) NSString *token;

@end

@implementation CXRequestAuthenticationAdapter

- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
    }
    return self;
}

- (void)adapted:(NSMutableURLRequest *)urlRequest
     withRequet:(CXRequest *)request
      withError:(NSError *__autoreleasing  _Nullable *)error
{
    if (request.authentication == CXAuthenticateMethodNone ||
        !self.token ||
        self.token.length < 1)
    {
        [urlRequest setValue:nil forHTTPHeaderField:@"Authorization"];
        return;
    }
    
    NSString *token = self.token;
    if (![token hasPrefix:@"Bearer"]) {
        token = [NSString stringWithFormat:@"Bearer %@", token];
    }
    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
}

@end
