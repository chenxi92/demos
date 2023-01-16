//
//  CXLoginResponseModel.m
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import "CXLoginResponseModel.h"

@implementation CXLoginResponseModel

+ (instancetype)parse:(NSDictionary *)response {
    return [[CXLoginResponseModel alloc] initWithResponse:response];
}

- (instancetype)initWithResponse:(NSDictionary *)response {
    if (self = [super init]) {
        [self parse:response];
    }
    return self;
}

- (void)parse:(NSDictionary *)response {
    self.name       = [response objectForKey:@"name"];
    self.identifier = [response objectForKey:@"id"];
    self.userId     = [response objectForKey:@"userId"];
    self.roleId     = [response objectForKey:@"roleId"];
}

@end
