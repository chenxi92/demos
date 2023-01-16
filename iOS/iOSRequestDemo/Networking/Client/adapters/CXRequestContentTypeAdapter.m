//
//  CXRequestContentTypeAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXRequestContentTypeAdapter.h"
#import "CXRequest.h"

@implementation CXRequestContentTypeAdapter

- (void)adapted:(NSMutableURLRequest *)urlRequest
     withRequet:(CXRequest *)request
      withError:(NSError *__autoreleasing  _Nullable *)error
{
    NSString *value = @"";
    if (request.contentType == CXContentTypeForm) {
        value = @"application/x-www-form-urlencoded; charset=utf-8";
    } else if (request.contentType == CXContentTypeJson) {
        value = @"application/json";
    }
    [urlRequest setValue:value forHTTPHeaderField:@"Content-Type"];
}

@end
