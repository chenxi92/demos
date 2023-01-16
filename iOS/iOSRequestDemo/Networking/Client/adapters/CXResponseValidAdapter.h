//
//  CXResponseValidAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import "CXResponseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// An adapter to verify the response code.
@interface CXResponseValidAdapter : NSObject <CXResponseAdapter>

/// The valid code.
///
/// Default is: 200.
@property (nonatomic, assign) int validCode;

@end

NS_ASSUME_NONNULL_END
