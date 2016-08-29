//
//  LALocal.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/9/8.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LALocal.h"
#import "LALocalRequest.h"

@interface LALocal ()

@property (nonatomic, strong) NSMutableArray<LALocalRequestMaker *> *list;

@end

@implementation LALocal

+ (void)createAPI:(void (^)(LALocalRequestMaker *))maker {
    if (!maker) {
        return;
    }
    
    LALocalRequestMaker *lalrm = [LALocalRequestMaker new];
    maker(lalrm);
    [[[self shared] list] addObject:lalrm];
}

+ (NSDictionary *)invokeRequest:(NSString *)url param:(NSDictionary *)param {
    NSURL *u = [NSURL URLWithString:url];
    for (LALocalRequestMaker *maker in [[self shared] list]) {
        if ([maker match:u]) {
            LALocalRequest *request = [LALocalRequest new];
            request.request = url;
            NSMutableDictionary *dic = [[self shared] paramsFromEncodedQuery:[u query]] ? : [NSMutableDictionary new];
            [dic addEntriesFromDictionary:param];
            request.param = dic;
            return [maker.implement invoke:request];
        }
    }
    
    return nil;
}

- (NSMutableDictionary *)paramsFromEncodedQuery:(NSString *)query
{
    NSArray *param = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *p in param) {
        NSArray *kv = [p componentsSeparatedByString:@"="];
        if ([kv count] == 2) {
            dic[kv[0]] = [self URLDecode:kv[1]];
        }
    }
    
    return dic;
}

- (NSString *)URLDecode:(NSString *)encoded {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    NSString *decodedString =
    (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                          (__bridge CFStringRef)self,
                                                                                          CFSTR(""),
                                                                                          CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
#else
    NSString *decodedString = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapes(nil, (__bridge CFStringRef)encoded, CFSTR(""));
#endif
    
    return decodedString;
}

#pragma mark - life cycle

+ (instancetype)shared {
    static LALocal *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.list = [NSMutableArray new];
    }
    return self;
}

@end
