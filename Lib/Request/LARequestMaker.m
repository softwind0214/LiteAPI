//
//  LARequestMaker.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/5.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LARequestMaker.h"
#import "LACore.h"
#import "LATemplate.h"

static NSArray *LAMethodMap = nil;

@interface LARequestMaker ()

@property (nonatomic, strong) LADictionary *head;
@property (nonatomic, strong) LADictionary *param;
@property (nonatomic, strong) LACallback *willInvoke;
@property (nonatomic, strong) LACallback *afterInvoke;

@property (nonatomic, strong) NSString *v_method;
@property (nonatomic, strong) NSString *v_host;
@property (nonatomic, strong) NSString *v_version;
@property (nonatomic, strong) NSString *v_path;

@property (nonatomic, assign) LAPostStyle v_postStyle;
@property (nonatomic, assign) LAResponseStyle v_responseStyle;
@property (nonatomic, assign) BOOL v_sync;

@end

@implementation LARequestMaker

#pragma mark - publics

- (LARequestMaker *(^)(NSString *))host {
    return ^id(NSString *value) {
        self.v_host = value;
        return self;
    };
}

- (LARequestMaker *(^)(NSString *))version {
    return ^id(NSString *value) {
        self.v_version = value;
        return self;
    };
}

- (LARequestMaker *(^)(NSString *))path {
    return ^id(NSString *value) {
        self.v_path = value;
        return self;
    };
}

- (LARequestMaker *(^)(LAMethod))method {
    return ^id(LAMethod value) {
        self.v_method = LAMethodMap[value];
        return self;
    };
}

- (LARequestMaker *(^)(LAPostStyle))post {
    return ^id(LAPostStyle value) {
        self.v_postStyle = value;
        return self;
    };
}

- (LARequestMaker *(^)(LAResponseStyle))response {
    return ^id(LAResponseStyle value) {
        self.v_responseStyle = value;
        return self;
    };
}

- (LARequestMaker *(^)(BOOL))sync {
    return ^id(BOOL value) {
        self.v_sync = value;
        return self;
    };
}

- (LARequestMaker *(^)(LAIdentifier))import {
    return ^id(LAIdentifier identifier) {
        LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:identifier];
        if (maker) {
            [self doImport:maker];
        }
        return self;
    };
}

- (LARequestMaker *(^)(LAIdentifier, LAStatus))certainImport {
    return ^id(LAIdentifier identifier, LAStatus status) {
        LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:identifier
                                                                   onStatus:status];
        if (maker) {
            [self doImport:maker];
        }
        return self;
    };
}

- (LARequest *)make {
    NSString *url = nil;
    if (self.v_version) {
        url = [NSString stringWithFormat:@"%@/%@%@",
               self.v_host,
               self.v_version,
               self.v_path];
    } else {
        url = [NSString stringWithFormat:@"%@%@",
               self.v_host,
               self.v_path];
    }
    
    NSMutableURLRequest *request = [LACore makeRequest:url method:self.v_method
                                                  post:self.v_postStyle
                                                params:self.param.property];
    NSDictionary *headers = self.head.property;
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    
    LARequest *result = [LARequest new];
    result.request = request;
    result.synchronous = self.v_sync;
    result.responseStyle = self.v_responseStyle;
    return result;
}

#pragma mark - private

- (void)doImport:(LARequestMaker *)value {
    self.v_method = value.v_method;
    self.v_host = value.v_host;
    self.v_version = value.v_version;
    self.v_path = value.v_path;
    self.v_responseStyle = value.v_responseStyle;
    self.v_sync = value.v_sync;
    self.head.set(value.head);
    self.param.set(value.param);
    self.willInvoke.set(value.willInvoke);
    self.afterInvoke.set(value.afterInvoke);
}

#pragma mark - life cycle

+ (void)load {
    LAMethodMap = @[@"GET", @"POST", @"PUT", @"DELETE"];
}

- (instancetype)init {
    if (self = [super init]) {
        self.head = [LADictionary new];
        self.param = [LADictionary new];
        self.willInvoke = [LACallback new];
        self.afterInvoke = [LACallback new];
        self.v_postStyle = LAPostStyleJSON;
        self.v_responseStyle = LAResponseStyleJSON;
        self.v_sync = NO;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *str = [NSMutableString stringWithString:@""];
    if (self.v_method) {
        [str appendFormat:@"[%@]", self.v_method];
    } else {
        [str appendString:@"[ANY]"];
    }
    
    [str appendString:self.v_host];
    if (self.v_version) {
        [str appendFormat:@"/%@", self.v_version];
    }
    if (self.v_path) {
        [str appendString:self.v_path];
    } else {
        [str appendString:@"/<PATH>"];
    }
    
    if (self.v_sync) {
        [str appendString:@", SYNC"];
    } else {
        [str appendString:@", ASYNC"];
    }
    [str appendString:@"\n"];

    NSString *temp = self.head.description;
    if (temp) {
        [str appendFormat:@"[Additional Header]%@\n", temp];
    }

    temp = self.param.description;
    if (temp) {
        [str appendFormat:@"[Additional Param]%@\n", temp];
    }
    
    temp = self.willInvoke.description;
    if (temp) {
        [str appendFormat:@"[Before Request]%@\n", temp];
    }
    
    temp = self.afterInvoke.description;
    if (temp) {
        [str appendFormat:@"[Before Response]%@\n", temp];
    }
    
    return str;
}

@end
