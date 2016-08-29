//
//  LA.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADefine.h"
#import "LARequestMaker.h"

@interface LA : NSObject

/**
 *  Invoke an API with maker. In order not to block the application, You should NOT invoke an synchronous request on main thread.
 *
 *  @param maker API maker
 *
 *  @return Instance of LAResponse if your API request is synchronous, otherwise nil.
 */
+ (id)invokeRequest:(void(^)(LARequestMaker *maker))maker;

/**
 *  Create your API template
 *
 *  @param maker      your template
 *  @param identifier identifier for template
 *  @param status     API status for template
 */
+ (void)createTemplate:(void(^)(LARequestMaker *maker))maker
        withIdentifier:(LAIdentifier)identifier
              onStatus:(LAStatus)status;

#pragma mark - common configs

/**
 *  Change your API status. Default LAStatusBeta
 */
+ (void)changeStatusTo:(LAStatus)status;

/**
 *  Default NO
 */
+ (void)enableAPILog:(BOOL)enable;

@end
