//
//  LALocal.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/9/8.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LALocalRequestMaker.h"
#import "LADefine.h"

@interface LALocal : NSObject

/**
 *  Create a local API
 */
+ (void)createAPI:(void(^)(LALocalRequestMaker *maker))maker;

/**
 *  Invoke a local API request.
 *
 *  @param url   <scheme>://<host><path>?<param>
 *  @param param Additional params, will be merged with get params of url.
 *
 *  @return API response.
 */
+ (NSDictionary *)invokeRequest:(NSString *)url param:(NSDictionary *)param;

@end
