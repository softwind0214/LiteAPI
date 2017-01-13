//
//  LAResponse.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LAResponse.h"

@interface LAResponse ()

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSDictionary *JSON;
@property (nonatomic, strong) NSData *stream;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) LAResponseStyle style;
@property (nonatomic, strong) NSDictionary *header;

@property (nonatomic, strong) NSString *url;

@end

@implementation LAResponse

+ (instancetype)response:(NSURLResponse *)response style:(LAResponseStyle)style data:(id)data error:(NSError *)error {
    
    NSHTTPURLResponse *http = (NSHTTPURLResponse *)response;
    LAResponse *resp = [self new];
    resp.style =  style;
    resp.statusCode = http.statusCode;
    resp.error = error;
    resp.url = http.URL.absoluteString;
    resp.header = http.allHeaderFields;
    
    switch (resp.style) {
        case LAResponseStyleJSON:
            resp.JSON = data;
            break;
            
        case LAResponseStyleStream:
            resp.stream = data;
            break;
            
        case LAResponseStyleCustom:
            //TODO
        default:
            break;
    }
    return resp;
}

- (NSString *)description {
    NSMutableString *str = [NSMutableString stringWithString:@"\n---------------------------API Response---------------------------\n"];
    [str appendFormat:@"[REQUEST]: %@\n", self.url];
    [str appendFormat:@"[STATUS]: %@\n", LAntoa(self.statusCode)];
    [str appendFormat:@"[STYLE]: %@\n", LAntoa(self.style)];
    [str appendFormat:@"[ERROR]: %@\n", self.error];
    [str appendFormat:@"[HEAD]: %@\n", self.header];
    [str appendFormat:@"[DATA]: %@\n", self.JSON ? : self.stream];
    [str appendString:@"---------------------------Response End---------------------------\n"];
    return str;
}

@end
