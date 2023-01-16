//
//  CXRequest.h
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import <Foundation/Foundation.h>
#import "CXRequestAdapter.h"
#import "CXResponseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CXHTTPMethodGET,
    CXHTTPMethodPOST,
    CXHTTPMethodPUT,
    CXHTTPMethodDELETE,
} CXHTTPMethod;

typedef enum : NSUInteger {
    CXContentTypeForm,
    CXContentTypeJson,
} CXContentType;

typedef enum : NSUInteger {
    CXAuthenticateMethodNone,
    CXAuthenticateMethodToken,
} CXAuthenticateMethod;


@interface CXRequest<ResonseObject>: NSObject

@property (nonatomic, copy) NSString *baseURLString;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, strong) NSDictionary *queryItems;

@property (nonatomic, strong) NSDictionary *parameters;

/// Default is `CXHTTPMethodGET`.
@property (nonatomic, assign) CXHTTPMethod method;

/// Default is `CXContentTypeForm`.
@property (nonatomic, assign) CXContentType contentType;

/// Default is `CXAuthenticateMethodNone`.
@property (nonatomic, assign) CXAuthenticateMethod authentication;

/// Default is 30 seconds.
@property (nonatomic, assign) NSTimeInterval timeout;

/// Default is `NSURLRequestReloadIgnoringLocalCacheData`.
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/// Adapters to modify the `NSURLRequest` object.
@property (nonatomic, strong, readonly) NSMutableArray <CXRequestAdapter> *requestAdapters;

/// Adapter to handle response object.
/// Default is nil.
@property (nonatomic, strong) NSObject <CXResponseAdapter> *responseAdapter;

/// The full url path.
@property (nonatomic, copy, readonly) NSString *urlString;

- (void)addRequestAdapter:(NSObject <CXRequestAdapter> *)adapter;

@end

NS_ASSUME_NONNULL_END
