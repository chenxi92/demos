//
//  CXLoginRequestModel.m
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import "CXLoginRequestModel.h"

@implementation CXLoginRequestModel

- (NSDictionary *)toDictionary {
    return @{
        @"name": self.name ?: @"",
        @"id": self.identifier ?: @""
    };
}

@end
