//
//  CXResponseValidAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import "CXResponseValidAdapter.h"

@implementation CXResponseValidAdapter

- (instancetype)init {
    if (self = [super init]) {
        _validCode = 200;
    }
    return self;
}

- (NSDictionary *)adapted:(NSURLResponse *)response
                 withData:(NSData *)data
                withError:(NSError *__autoreleasing  _Nullable *)error
{

    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];
    if (!responseDictionary) {
        return nil;
    }
    
    NSNumber *code = [responseDictionary objectForKey:@"code"];
    if (!code) {
        code = [NSNumber numberWithInt:-1];
    }
    
    if (code.intValue != self.validCode) {
        NSString *message = [responseDictionary objectForKey:@"msg"] ?: @"";
        *error = [NSError errorWithDomain:@"sdk.server.error" code:code.intValue userInfo:@{
            NSLocalizedDescriptionKey : message
        }];
        return nil;
    }
    
    return responseDictionary;
}

@end
