//
//  LALocalRequestMaker.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/9/8.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LALocalRequestMaker.h"

@interface LALocalRequestMaker ()

@property (nonatomic, strong) LACallback *implement;

@property (nonatomic, strong) NSString *v_scheme;
@property (nonatomic, strong) NSString *v_host;
@property (nonatomic, strong) NSString *v_path;

@end

@implementation LALocalRequestMaker

- (LALocalRequestMaker *(^)(NSString *))scheme {
    return ^id(NSString *value) {
        self.v_scheme = value;
        return self;
    };
}

- (LALocalRequestMaker *(^)(NSString *))host {
    return ^id(NSString *value) {
        self.v_host = value;
        return self;
    };
}

- (LALocalRequestMaker *(^)(NSString *))path {
    return ^id(NSString *value) {
        self.v_path = value;
        return self;
    };
}

- (BOOL)match:(NSURL *)url {
    if (self.v_scheme && ![self.v_scheme isEqualToString:url.scheme]) {
        return NO;
    }
    if (self.v_host && ![self.v_host isEqualToString:url.host]) {
        return NO;
    }
    if (self.v_path && ![self.v_path isEqualToString:url.path]) {
        return NO;
    }
    return YES;
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.implement = [LACallback new];
    }
    return self;
}

@end
