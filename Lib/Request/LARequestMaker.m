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
@property (nonatomic, strong) LACallback *willStart;
@property (nonatomic, strong) LACallback *didFinish;

@property (nonatomic, strong) NSString *v_method;
@property (nonatomic, strong) NSString *v_host;
@property (nonatomic, strong) NSString *v_version;
@property (nonatomic, strong) NSString *v_path;
@property (nonatomic, strong) NSData *v_customBody;

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

- (LARequestMaker *(^)(NSData *))body {
    return ^id(NSData * value) {
        self.v_customBody = value;
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
    NSMutableString *url = [NSMutableString stringWithString:@""];
    if (self.v_host) {
        [url appendString:self.v_host];
    }
    if (self.v_version) {
        [url appendFormat:@"/%@", self.v_version];
    }
    if (self.v_path) {
        [url appendString:self.v_path];
    }
    
    NSMutableURLRequest *request = [LACore makeRequest:url method:self.v_method
                                                  post:self.v_postStyle
                                                params:self.param.property];
    NSDictionary *headers = self.head.property;
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    
    if ((self.v_postStyle == LAPostStyleCustom) && (self.v_customBody)) {
        request.HTTPBody = self.v_customBody;
    }
    
    LARequest *result = [LARequest new];
    result.request = request;
    result.param = self.param.property;
    result.synchronous = self.v_sync;
    result.responseStyle = self.v_responseStyle;
    result.postStyle = self.v_postStyle;
    return result;
}

#pragma mark - private

- (void)doImport:(LARequestMaker *)value {
    self.v_method = value.v_method;
    self.v_host = value.v_host;
    self.v_version = value.v_version;
    self.v_path = value.v_path;
    self.v_customBody = value.v_customBody;
    self.v_responseStyle = value.v_responseStyle;
    self.v_postStyle = value.v_postStyle;
    self.v_sync = value.v_sync;
    self.head.set(value.head);
    self.param.set(value.param);
    self.willStart.set(value.willStart);
    self.didFinish.set(value.didFinish);
}

#pragma mark - life cycle

+ (void)initialize {
    LAMethodMap = @[@"GET", @"POST", @"PUT", @"DELETE"];
}

- (instancetype)init {
    if (self = [super init]) {
        self.head = [LADictionary new];
        self.param = [LADictionary new];
        self.willStart = [LACallback new];
        self.didFinish = [LACallback new];
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
        [str appendFormat:@"[Header]%@\n", temp];
    }

    temp = self.param.description;
    if (temp) {
        [str appendFormat:@"[Param]%@\n", temp];
    }
    
    temp = self.willStart.description;
    if (temp) {
        [str appendFormat:@"[will Start]%@\n", temp];
    }
    
    temp = self.didFinish.description;
    if (temp) {
        [str appendFormat:@"[did Finish]%@\n", temp];
    }
    
    return str;
}

@end
