//
//  LA.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LA.h"
#import "LACore.h"
#import "LARequest.h"
#import "LAResponse.h"
#import "LATemplate.h"

@interface LA ()

@property (nonatomic, assign) BOOL showLogs;

@end

@implementation LA

+ (id)invokeRequest:(void (^)(LARequestMaker *))maker {
    LARequestMaker *larm = [LARequestMaker new];
    maker(larm);
    LARequest * request = [larm make];
    __block LAResponse *res = nil;
    
    [larm.willInvoke invoke:request.request];
    if ([[self shared] showLogs]) {
        NSLog(@"%@", request);
    }
    if (request.synchronous) {
//        assert(![NSThread currentThread].isMainThread);
        __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [LACore invokeRequest:request callBack:^(NSURLResponse *response, id responseObject, NSError *error) {
            res = [LAResponse response:response
                                 style:request.responseStyle
                                  data:responseObject
                                 error:error];
            if ([[self shared] showLogs]) {
                NSLog(@"%@", res);
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return res;
    } else {
        [LACore invokeRequest:request callBack:^(NSURLResponse *response, id responseObject, NSError *error) {
            res = [LAResponse response:response
                                 style:request.responseStyle
                                  data:responseObject
                                 error:error];
            if ([[self shared] showLogs]) {
                NSLog(@"%@", res);
            }
            [larm.afterInvoke invoke:res];
        }];
    }
    
    return nil;
}

+ (void)createTemplate:(void (^)(LARequestMaker *))maker withIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status {
    LARequestMaker *larm = [LARequestMaker new];
    maker(larm);
    [[LATemplate shared] registerTemplate:larm
                           withIdentifier:identifier
                                 onStatus:status];
}

+ (void)changeStatusTo:(LAStatus)status {
    [LATemplate shared].status = status;
}

+ (void)enableAPILog:(BOOL)enable {
    LA *la = [self shared];
    la.showLogs = enable;
}

#pragma mark - life cycle

+ (instancetype)shared {
    static LA *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LA new];
    });
    
    return instance;
}

@end
