//
//  LARequest.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/5.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LARequest.h"

@implementation LARequest

- (NSString *)description {
    NSMutableString *str = [NSMutableString stringWithString:@"\n---------------------------API Request---------------------------\n"];
    [str appendFormat:@"[URL]: %@\n", self.request.URL];
    [str appendFormat:@"[METHOD]: %@\n", self.request.HTTPMethod];
    [str appendFormat:@"[SYNCHRONOUS]: %d\n", self.synchronous];
    [str appendFormat:@"[BODY]: %@\n", [[NSString alloc] initWithData:self.request.HTTPBody
                                                           encoding:NSUTF8StringEncoding]];
    [str appendFormat:@"[HEAD]: %@\n", self.request.allHTTPHeaderFields];
    [str appendString:@"---------------------------Request End---------------------------\n"];
    return str;
}

@end
