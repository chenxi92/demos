//
//  CXRequestJsonParameterEncryptAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXRequestJsonParameterEncryptAdapter.h"
#import "CXRequest.h"

@implementation CXRequestJsonParameterEncryptAdapter

- (void)adapted:(NSMutableURLRequest *)urlRequest
     withRequet:(CXRequest *)request
      withError:(NSError *__autoreleasing  _Nullable *)error
{
    if (request.method != CXHTTPMethodPOST) {
        return;
    }
    NSDictionary *encryptedParameter;
    if (self.encryptBlock) {
        encryptedParameter = self.encryptBlock(request.parameters);
    } else {
        encryptedParameter = request.parameters;
    }
    urlRequest.HTTPBody = [self dictionaryToData:encryptedParameter];
}

@end
