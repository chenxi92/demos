//
//  CXRequest.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXRequest.h"
#import "CXRequestContentTypeAdapter.h"
#import "CXRequestHTTPMethodAdapter.h"
#import "CXRequestAuthenticationAdapter.h"
#import "NSString+URL.h"


@interface CXRequest()
@property (nonatomic, strong, readwrite) NSMutableArray <CXRequestAdapter>*requestAdapters;
@end

@implementation CXRequest

#pragma mark - Lift Circle

- (instancetype)init {
    if (self = [super init]) {
        _method = CXHTTPMethodGET;
        _contentType = CXContentTypeForm;
        _authentication = CXAuthenticateMethodNone;
        _timeout = 30;
        _cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _requestAdapters = (id)[NSMutableArray new];
        
        [self setupDefaultRequestAdapters];
    }
    return self;
}

#pragma mark - Setter

- (void)setBaseURLString:(NSString *)baseURLString {
    if ([baseURLString hasSuffix:@"/"]) {
        _baseURLString = [baseURLString substringToIndex:baseURLString.length - 1];
    } else {
        _baseURLString = baseURLString;
    }
}

- (void)setPath:(NSString *)path {
    if ([path hasPrefix:@"/"]) {
        _path = [path substringFromIndex:1];
    } else {
        _path = path;
    }
}

#pragma mark - Public

- (NSString *)urlString {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURLString, self.path];
    NSString *queryString = [self queryString];
    if (queryString) {
        urlString = [NSString stringWithFormat:@"%@?%@", urlString, queryString];
    }
    return urlString;
}

- (void)addRequestAdapter:(NSObject<CXRequestAdapter> *)adapter {
    [self.requestAdapters addObject:adapter];
}

#pragma mark - Private

- (void)setupDefaultRequestAdapters {
    [self.requestAdapters addObject:[CXRequestHTTPMethodAdapter new]];
    [self.requestAdapters addObject:[CXRequestContentTypeAdapter new]];
}

- (NSString *)queryString {
    if (self.queryItems) {
        NSMutableArray *sortedItems = [NSMutableArray array];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
        NSArray *sortedKeys = [self.queryItems.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
        for (NSString *key in sortedKeys) {
            NSString *handledValue = nil;
            id value = [self.queryItems objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                handledValue = [(NSString *)value cx_urlEncode];
            } else if ([value isKindOfClass:[NSNumber class]]) {
                handledValue = [[(NSNumber *)value stringValue] cx_urlEncode];
            }
            if (key && handledValue) {
                NSString *component = [NSString stringWithFormat:@"%@=%@", key, handledValue];
                if (component) {
                    [sortedItems addObject:component];
                }
            }
        }
        if (sortedItems.count > 0) {
            return [sortedItems componentsJoinedByString:@"&"];
        }
    }
    return nil;
}

@end

