//
//  ViewController.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/5.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "ViewController.h"
#import "LiteAPI.h"
#import "LATemplate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LA enableAPILog:YES];
    
    [LA createTemplate:^(LARequestMaker *maker) {
        maker.host(@"http://api.kagou.me").version(@"v1").method(LAMethodGET).post(LAPostStyleForm).sync(NO).response(LAResponseStyleJSON);
        maker.willInvoke.delegate(self, @selector(sign:));
    }
        withIdentifier:@"aaa"
              onStatus:LAStatusProduction];
    [LA createTemplate:^(LARequestMaker *maker) {
        maker.certainImport(@"aaa", LAStatusProduction).host(@"http://api.test.kagou.me");
        maker.afterInvoke.delegate(self, @selector(sign:));
    }
        withIdentifier:@"aaa"
              onStatus:LAStatusBeta];
    [LA changeStatusTo:LAStatusBeta];
    
    NSLog(@"%@", [LATemplate shared]);
    
    [LA invokeRequest:^(LARequestMaker *maker) {
        maker.import(@"aaa").path(@"/ping");
//        maker.beforeResponse.delegate(self, @selector(handleAPI:));
        maker.afterInvoke.block(^id(LAResponse *response){
            NSLog(@"%@", response.JSON);
            return nil;
        });
        NSLog(@"\nAPI:%@", maker);
    }];
    
    LAResponse *resp = [LA invokeRequest:^(LARequestMaker *maker) {
        maker.import(@"aaa").path(@"/ping").sync(YES).response(LAResponseStyleStream);
    }];
    NSLog(@"%@", resp);
}

- (id)sign:(NSMutableURLRequest *)request {
    return nil;
}

- (id)handleAPI:(id)value {
    return value;
}

@end
