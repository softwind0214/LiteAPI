//
//  LACore.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADefine.h"
#import "LARequest.h"

/**
 *  bottom layer network framework linker
 */
@interface LACore : NSObject

+ (void)invokeRequest:(LARequest *)request
             callBack:(void(^)(NSURLResponse *response, id responseObject, NSError *error))block;

+ (NSMutableURLRequest *)makeRequest:(NSString *)url
                              method:(NSString *)method
                                post:(LAPostStyle)style
                              params:(NSDictionary *)params;
@end
