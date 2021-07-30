//
//  GithubRepository.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GithubRepository : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *shortDescription;

@property (nonatomic, copy) NSURL *url;

- (instancetype)initWithName:(NSString *)name shortDescription:(NSString *)shortDescription url:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
