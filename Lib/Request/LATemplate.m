//
//  LATemplate.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/26.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LATemplate.h"

@interface LATemplate ()

@property (nonatomic, strong) NSArray<NSMutableDictionary<NSString *, id> *> *table;

@end

@implementation LATemplate

#pragma mark - publics

- (void)registerTemplate:(id)template withIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status {
    self.table[status][identifier] = template;
}

- (id)templateWithIdentifier:(LAIdentifier)identifier {
    return [self templateWithIdentifier:identifier onStatus:self.status];
}

- (id)templateWithIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status {
    return self.table[status][identifier];
}

- (NSArray *)allIdentifiers {
    
    __block NSMutableSet *set = [NSMutableSet set];
    [self.table enumerateObjectsUsingBlock:^(NSMutableDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObjectsFromArray:obj.allKeys];
    }];
    return set.allObjects;
}

#pragma mark - life cycle

+ (instancetype)shared {
    static LATemplate *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.table = [NSArray arrayWithObjects:
                      [NSMutableDictionary dictionary],
                      [NSMutableDictionary dictionary],
                      [NSMutableDictionary dictionary],
                      nil];
        self.status = LAStatusBeta;
    }
    
    return self;
}

- (NSString *)description {
    __block NSMutableString *str = [NSMutableString stringWithString:@"\n"];
    [self.table enumerateObjectsUsingBlock:^(NSMutableDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *key in obj.keyEnumerator) {
            [str appendFormat:@"-------------------------API TEMPLATE[%@][%ld]-------------------------\n", key, idx];
            [str appendString:[obj[key] description]];
            [str appendFormat:@"-------------------------TEMPLATE END[%@][%ld]-------------------------\n", key, idx];
        }
    }];
    
    return str;
}


@end
