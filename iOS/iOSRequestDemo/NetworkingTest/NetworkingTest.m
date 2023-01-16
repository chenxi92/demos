//
//  NetworkingTest.m
//  NetworkingTest
//
//  Created by peak on 2023/1/16.
//

#import <XCTest/XCTest.h>
#import "CXRequest.h"
#import "CXRequestAuthenticationAdapter.h"
#import "CXRequestJsonParameterEncryptAdapter.h"

@interface NetworkingTest : XCTestCase

@end

@implementation NetworkingTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_1_request_init {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    CXRequest *request = [[CXRequest alloc] init];
    
    XCTAssertTrue(request.method == CXHTTPMethodGET);
    XCTAssertTrue(request.contentType == CXContentTypeForm);
    XCTAssertTrue(request.authentication == CXAuthenticateMethodNone);
    XCTAssertTrue(request.timeout == 30);
    XCTAssertTrue(request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData);
    XCTAssertTrue(request.requestAdapters.count == 2);
    XCTAssertNil(request.responseAdapter);
}

- (void)test_2_request_get {
    CXRequest *request = [[CXRequest alloc] init];
    request.baseURLString = @"https://my-host.com/22/";
    request.path = @"/query/url";
    XCTAssertTrue([request.urlString isEqualToString:@"https://my-host.com/22/query/url"]);
    
    request.queryItems = @{
        @"a": @"a a",
        @"b": @"b=b",
        @"c": @"c%b"
    };
    XCTAssertTrue([request.urlString isEqualToString:@"https://my-host.com/22/query/url?a=a%20a&b=b%3Db&c=c%25b"]);
    
    request.authentication = CXAuthenticateMethodToken;
    
    CXRequestAuthenticationAdapter *authenticateAdapter = [[CXRequestAuthenticationAdapter alloc] initWithToken:@"1234567890"];
    [request addRequestAdapter:authenticateAdapter];
    
    XCTAssertTrue(request.requestAdapters.count == 3);
    
    NSError *error;
    NSURLRequest *urlRequest = [self create:request error:&error];
    XCTAssertNil(error);
    
    XCTAssertTrue([urlRequest.allHTTPHeaderFields[@"Authorization"] isEqualToString:@"Bearer 1234567890"]);
    
    NSLog(@"== %@", urlRequest);
    NSLog(@"== %@", urlRequest.allHTTPHeaderFields.description);
    NSLog(@"== %@", urlRequest.URL.absoluteString);
}

- (void)test_3_request_post {
    CXRequest *request = [[CXRequest alloc] init];
    request.method = CXHTTPMethodPOST;
    request.contentType = CXContentTypeJson;
    request.baseURLString = @"https://my-host.com/22/";
    request.path = @"/query/url";
    XCTAssertTrue([request.urlString isEqualToString:@"https://my-host.com/22/query/url"]);
    
    request.queryItems = @{
        @"a": @"a a",
        @"b": @"b=b",
        @"c": @"c%b"
    };
    XCTAssertTrue([request.urlString isEqualToString:@"https://my-host.com/22/query/url?a=a%20a&b=b%3Db&c=c%25b"]);
    
    [request addRequestAdapter:[CXRequestAuthenticationAdapter new]];
    XCTAssertTrue(request.requestAdapters.count == 3);
    
    request.parameters = @{
        @"k1": @"v1",
        @"k2": @"v2"
    };
    CXRequestJsonParameterEncryptAdapter *encryptAdapter = [CXRequestJsonParameterEncryptAdapter new];
    encryptAdapter.encryptBlock = ^NSDictionary * _Nonnull(NSDictionary * _Nonnull parameter) {
        NSMutableDictionary *adaptedParameter = [NSMutableDictionary dictionary];
        for (NSString *key in parameter) {
            NSString *prefix = @"kxABd_";
            NSString *newValue = [NSString stringWithFormat:@"%@%@", prefix, [parameter objectForKey:key]];
            [adaptedParameter setObject:newValue forKey:key];
        }
        return [adaptedParameter copy];
    };
    [request addRequestAdapter:encryptAdapter];
    XCTAssertTrue(request.requestAdapters.count == 4);
    
    NSError *error;
    NSURLRequest *urlRequest = [self create:request error:&error];
    XCTAssertNil(error);
    
    XCTAssertNil([urlRequest.allHTTPHeaderFields objectForKey:@"Authorization"]);
    
    NSString *adaptedParameter = [NSJSONSerialization JSONObjectWithData:urlRequest.HTTPBody options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"adapted parameter = %@", adaptedParameter);
    
    NSLog(@"== %@", urlRequest);
    NSLog(@"== %@", urlRequest.allHTTPHeaderFields.description);
    NSLog(@"== %@", urlRequest.URL.absoluteString);
}

- (NSURLRequest *)create:(CXRequest *)request error:(NSError **)error {
    NSURL *url = [NSURL URLWithString:request.urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:request.cachePolicy timeoutInterval:request.timeout];
    for (NSObject <CXRequestAdapter> *adaptor in request.requestAdapters) {
        [adaptor adapted:urlRequest withRequet:request withError:error];
        if (*error) {
            break;
        }
    }
    return urlRequest;
}

@end
