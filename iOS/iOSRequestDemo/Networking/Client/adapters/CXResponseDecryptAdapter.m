//
//  CXResponseDecryptAdapter.m
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import "CXResponseDecryptAdapter.h"

@implementation CXResponseDecryptAdapter

- (NSDictionary *)adapted:(NSURLResponse *)response
                 withData:(NSData *)data
                withError:(NSError *__autoreleasing  _Nullable *)error
{
    NSDictionary *responseDictionary = [super adapted:response withData:data withError:error];
    if (!responseDictionary) {
        return nil;
    }
    
    // some logic about the current
    NSDictionary *dataInfo = [responseDictionary objectForKey:@"data"];
    if (!dataInfo) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];
        if (result) {
            dataInfo = [result objectForKey:@"data"];
        }
    }
    if (!dataInfo) {
        return nil;
    }
    
    if (self.decryptBlock) {
        // do decrypt 
        return self.decryptBlock(dataInfo);
    }
    return nil;
}

@end
