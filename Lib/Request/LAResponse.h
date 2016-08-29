//
//  LAResponse.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADefine.h"

@interface LAResponse : NSObject

@property (nonatomic, readonly) NSInteger statusCode;                   //!< HTTP request status code.
@property (nonatomic, readonly) NSDictionary *JSON;                     //!< use this if your response style is LAResponseStyleJSON
@property (nonatomic, readonly) NSData *stream;                         //!< use this if your response style is LAResponseStyleStream
@property (nonatomic, readonly) NSError *error;                         //!< HTTP request error
@property (nonatomic, readonly) LAResponseStyle style;                  //!< response style
@property (nonatomic, readonly) NSDictionary *header;                   //!< response header

+ (instancetype)response:(NSURLResponse *)response
                   style:(LAResponseStyle)style
                    data:(id)data
                   error:(NSError *)error;

@end
