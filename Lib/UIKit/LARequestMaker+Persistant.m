//
//  LARequestMaker+Persistant.m
//  LiteAPI
//
//  Created by Softwind Tang on 2016/12/23.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LARequestMaker+Persistant.h"

@implementation LARequestMaker (Persistant)

- (id)valueForRMKey:(NSString *)key {
    id value = [self valueForKey:key];
    if (!value) {
        value = [NSNull null];
    }
    return value;
}

- (NSDictionary<NSString *,id> *)dictionaryRepresentation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[self persistantKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        dic[obj] = [self valueForRMKey:obj];
    }];
    return dic;
}

- (void)dictionaryLoad:(NSDictionary<NSString *,id> *)dic {
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [self setValue:nil forKey:key];
        } else {
            [self setValue:obj forKey:key];
        }
    }];
}

- (NSArray<NSString *> *)persistantKeys {
    static NSArray<NSString *> *temp = nil;
    if (!temp) {
        temp = @[@"v_method", @"v_host", @"v_version", @"v_responseStyle", @"v_postStyle", @"v_sync"];
    }
    return temp;
}

@end
