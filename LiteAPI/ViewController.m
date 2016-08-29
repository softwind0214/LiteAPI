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
#import "LATable.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [LA enableAPILogs:YES];
    
    [LA createTemplate:^(LARequestMaker *maker) {
        maker.host(@"http://api.kagou.me").version(@"v1").method(LAMethodGET).post(LAPostStyleForm).sync(NO).response(LAResponseStyleJSON);
        maker.willStart.delegate(self, @selector(sign:));
    }
        withIdentifier:@"aaa"
              onStatus:LAStatusProduction];
    [LA createTemplate:^(LARequestMaker *maker) {
        maker.certainImport(@"aaa", LAStatusProduction).host(@"http://api.test.kagou.me");
        maker.didFinish.delegate(self, @selector(handleAPI:));
    }
        withIdentifier:@"aaa"
              onStatus:LAStatusBeta];
    [LA switchToStatus:LAStatusBeta];
    
    [LA loadPersistantData];
    LALog(@"%@", [LATemplate shared]);
    
    [LA invokeRequest:^(LARequestMaker *maker) {
        maker.import(@"aaa").path(@"/ping");
        maker.didFinish.block(^id(LAResponse *response){
            LALog(@"%@", response.JSON);
            return nil;
        });
        LALog(@"\nAPI:%@", maker);
    }];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        LAResponse *resp = [LA invokeRequest:^(LARequestMaker *maker) {
//            maker.import(@"aaa").path(@"/ping").sync(YES).response(LAResponseStyleStream);
//        }];
//        LALog(@"%@", resp);
//    });
    
    [LALocal createAPI:^(LALocalRequestMaker *maker) {
        maker.scheme(@"a.b.c").host(@"testapi");
        maker.implement.thread(LAThreadBackground).wait(NO).block(^NSDictionary *(LARequest *request){
            return request.param;
        });
    }];
    
    NSDictionary *result = [LALocal invokeRequest:@"a.b.c://testapi/aaaaa?b=c" param:@{@"userInfo":self}];
    LALog(@"%@", result);
    
    [LA enableRunningModifyWithGesture:nil on:self];
}

- (void)didTapButton:(id)sender {
    LATable *table = [[LATable alloc] init];
    table.navigationItem.title = @"设置API";
    [self.navigationController pushViewController:table animated:YES];
}

- (id)sign:(LARequest *)request {
    return request.request;
}

- (id)handleAPI:(id)value {
    return value;
}

@end
