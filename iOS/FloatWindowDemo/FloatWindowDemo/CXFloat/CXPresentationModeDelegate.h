//
//  CXPresentationModeDelegate.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CXPresentationMode) {
    CXPresentationModeFullWindow,
    CXPresentationModeCondensed,
    CXPresentationModeDisable,
};

NS_ASSUME_NONNULL_BEGIN

@protocol CXPresentationModeDelegate <NSObject>

- (void)presentationDelegateChangezpresentationModeToMode:(CXPresentationMode)mode;

@end

NS_ASSUME_NONNULL_END
