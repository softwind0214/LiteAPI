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
#import "LATable.h"
#import "LARequestMaker+Persistant.h"

@interface LA ()

@property (nonatomic, assign) BOOL showLogs;
@property (nonatomic, weak) UIViewController *runningModifyParent;

@end

@implementation LA

+ (id)invokeRequest:(void (^)(LARequestMaker *))maker {
    LARequestMaker *larm = [LARequestMaker new];
    maker(larm);
    LARequest * request = [larm make];
    __block LAResponse *res = nil;
    
    request.request =  [larm.willStart invoke:request];
    if ([[self shared] showLogs]) {
        LALog(@"%@", request);
    }
    if (request.synchronous) {
        assert(![NSThread currentThread].isMainThread);
        __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [LACore invokeRequest:request callBack:^(NSURLResponse *response, id responseObject, NSError *error) {
            res = [LAResponse response:response
                                 style:request.responseStyle
                                  data:responseObject
                                 error:error];
            if ([[self shared] showLogs]) {
                LALog(@"%@", res);
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
                LALog(@"%@", res);
            }
            [larm.didFinish invoke:res];
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

+ (void)switchToStatus:(LAStatus)status {
    LATemplate *lt = [LATemplate shared];
    for (LAIdentifier i in [lt allIdentifiers]) {
        [lt setStatus:status forTemplate:i];
    }
}

+ (void)switchToStatus:(LAStatus)status forTemplate:(LAIdentifier)identifier {
    LATemplate *lt = [LATemplate shared];
    [lt setStatus:status forTemplate:identifier];
}

+ (void)enableAPILogs:(BOOL)enable {
    LA *la = [self shared];
    la.showLogs = enable;
}

+ (void)enableRunningModifyWithGesture:(UIGestureRecognizer *)gesture on:(UIViewController *)vc {
    if (!vc || !vc.navigationController) {
        return;
    }
    
    LA *la = [LA shared];
    la.runningModifyParent = vc;
    
    UIGestureRecognizer *g = gesture;
    if (!g) {
        g = [[UITapGestureRecognizer alloc] initWithTarget:la
                                                    action:@selector(runningModify:)];
        ((UITapGestureRecognizer *)g).numberOfTapsRequired = 8;
    } else {
        [g addTarget:self
              action:@selector(runningModify:)];
    }
    [vc.view addGestureRecognizer:g];
}

- (void)runningModify:(id)sender {
    LATable *table = [LATable new];
    [self.runningModifyParent.navigationController pushViewController:table
                                                             animated:YES];
}

+ (void)loadPersistantData {
    NSData *temp = [[NSUserDefaults standardUserDefaults] dataForKey:LAPersistantKey];
    if (!temp) {
        return;
    }
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:temp options:NSJSONReadingAllowFragments error:nil];
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [[[LATemplate shared] allIdentifiers] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:key onStatus:LAStatusProduction];
        [maker dictionaryLoad:data[key][LAntoa(LAStatusProduction)]];
        maker = [[LATemplate shared] templateWithIdentifier:key onStatus:LAStatusBeta];
        [maker dictionaryLoad:data[key][LAntoa(LAStatusBeta)]];
        maker = [[LATemplate shared] templateWithIdentifier:key onStatus:LAStatusDevelop];
        [maker dictionaryLoad:data[key][LAntoa(LAStatusDevelop)]];
        [[LATemplate shared] setStatus:[data[key][@"status"] integerValue] forTemplate:key];
    }];
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
