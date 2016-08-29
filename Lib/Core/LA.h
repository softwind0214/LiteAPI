//
//  LA.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LADefine.h"
#import "LARequestMaker.h"

@interface LA : NSObject

#pragma mark - API

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

#pragma mark - status

/**
 *  Change all of your API status.
 */
+ (void)switchToStatus:(LAStatus)status;

/**
 *  Change one API status. Default LAStatusProduction for every API.
 *
 *  @param status     destination status
 *  @param identifier identifier for template
 */
+ (void)switchToStatus:(LAStatus)status
           forTemplate:(LAIdentifier)identifier;

#pragma mark - log

/**
 *  Default NO
 */
+ (void)enableAPILogs:(BOOL)enable;

#pragma mark - debug

/**
 *  If vc isn't nil, a LATable will be pushed after a certain guesture on vc.
 *  The default guesture is tapping for 8 times if gesture is nil.
 */
+ (void)enableRunningModifyWithGesture:(UIGestureRecognizer *)gesture on:(UIViewController *)vc;

/**
 *  Load the persistant data from NSUserDefaults if you have. See LATable.
 */
+ (void)loadPersistantData;

@end
