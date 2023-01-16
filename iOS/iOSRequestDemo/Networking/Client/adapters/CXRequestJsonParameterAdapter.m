//
//  CXRequestJsonParameterAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXRequestJsonParameterAdapter.h"
#import "CXRequest.h"

@implementation CXRequestJsonParameterAdapter

- (void)adapted:(NSMutableURLRequest *)urlRequest
     withRequet:(CXRequest *)request
      withError:(NSError *__autoreleasing  _Nullable *)error
{
    if (request.method != CXHTTPMethodPOST) {
        return;
    }
    urlRequest.HTTPBody = [self dictionaryToData:request.parameters];
}

- (NSData *)dictionaryToData:(NSDictionary *)dictionary {
    NSString *jsonString = [self dictionaryToJsonString:dictionary];
    if (!jsonString) {
        return nil;
    }
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)dictionaryToJsonString:(NSDictionary *)dictonary {
    if ([NSJSONSerialization isValidJSONObject:dictonary]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictonary options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) {
            return json;
        }
    }
    return nil;
}

@end
