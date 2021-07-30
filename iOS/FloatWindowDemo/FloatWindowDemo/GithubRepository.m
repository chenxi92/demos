//
//  GithubRepository.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "GithubRepository.h"

@implementation GithubRepository

- (instancetype)initWithName:(NSString *)name shortDescription:(NSString *)shortDescription url:(NSURL *)url {
    if (self = [super init]) {
        _name = name;
        _shortDescription = ([shortDescription class] != [NSNull class]) ? [shortDescription copy] : @"No Description";
        _url = url;
    }
    return self;
}
@end
