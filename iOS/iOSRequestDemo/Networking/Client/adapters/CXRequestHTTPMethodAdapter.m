//
//  CXRequestHTTPMethodAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXRequestHTTPMethodAdapter.h"
#import "CXRequest.h"

@implementation CXRequestHTTPMethodAdapter

- (void)adapted:(NSMutableURLRequest *)urlRequest
     withRequet:(CXRequest *)request
      withError:(NSError *__autoreleasing  _Nullable *)error
{
    NSString *value = @"";
    switch (request.method) {
        case CXHTTPMethodGET:
            value = @"GET";
            break;
        case CXHTTPMethodPOST:
            value = @"POST";
            break;
        case CXHTTPMethodPUT:
            value = @"PUT";
            break;
        default:
            value = @"DELETE";
            break;
    }
    
    urlRequest.HTTPMethod = value;
}

@end
