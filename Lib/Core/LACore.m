//
//  LACore.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LACore.h"
#import <AFNetworking/AFNetworking.h>

@interface LACore ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPRequestSerializer *normalRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *JSONRequestSerializer;

@end

@implementation LACore

+ (instancetype)shared {
    static LACore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.normalRequestSerializer = [AFHTTPRequestSerializer serializer];
        self.normalRequestSerializer.timeoutInterval = 20.0f;
        self.JSONRequestSerializer = [AFJSONRequestSerializer serializer];
        self.JSONRequestSerializer.timeoutInterval = 20.0f;
    }
    
    return self;
}

+ (NSMutableURLRequest *)makeRequest:(NSString *)url
                              method:(NSString *)method
                                post:(LAPostStyle)style
                              params:(NSDictionary *)params {
    
    NSMutableURLRequest *request = nil;
    LACore *core = [self shared];
    switch (style) {
        case LAPostStyleForm:
            request = [core.normalRequestSerializer requestWithMethod:method
                                                            URLString:url
                                                           parameters:params
                                                                error:nil];
            break;

        case LAPostStyleJSON:
            request = [core.JSONRequestSerializer requestWithMethod:method
                                                          URLString:url
                                                         parameters:params
                                                              error:nil];
            break;
            
        case LAPostStyleCustom:
        default:
            break;
    }

    return request;
}

+ (void)invokeRequest:(LARequest *)request
             callBack:(void (^)(NSURLResponse *, id, NSError *))block {
    
    LACore *core = [self shared];
    NSURLSessionDataTask *task = nil;
    if (request.responseStyle == LAResponseStyleStream) {
        task = [core.sessionManager.session dataTaskWithRequest:request.request
                                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                  block(response, data, error);
                                              }];
    } else {
        task = [core.sessionManager dataTaskWithRequest:request.request
                                         uploadProgress:^(NSProgress *uploadProgress){}
                                       downloadProgress:^(NSProgress *downloadProgress){}
                                      completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                          block(response, responseObject, error);
                                      }];
    }
    [task resume];
}

@end
