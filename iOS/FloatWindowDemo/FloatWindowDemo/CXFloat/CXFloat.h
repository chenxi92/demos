//
//  CXFloat.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXPresentationModeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXFloat : NSObject <CXPresentationModeDelegate>

- (void)enable;

- (void)disable;

@property (nonatomic, assign) CXPresentationMode presentationMode;

@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@end

NS_ASSUME_NONNULL_END
