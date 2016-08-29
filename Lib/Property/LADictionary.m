//
//  LADictionary.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LADictionary.h"

@interface LADictionary ()

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation LADictionary

- (instancetype)init {
    if (self = [super init]) {
        self.dic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (LAProperty *(^)(NSString *, NSString *))add {
    return ^id(NSString *key, NSString *value) {
        self.dic[key] = value;
        return self;
    };
}

#pragma mark - getters/setters

- (void)setProperty:(id)property {
    LADictionary *p = property;
    [self.dic removeAllObjects];
    [self.dic addEntriesFromDictionary:p.dic];
}

- (id)property {
    return self.dic;
}

#pragma mark - life cycle

- (NSString *)description {
    if (self.dic.count <= 0) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@", self.dic];
}

@end
