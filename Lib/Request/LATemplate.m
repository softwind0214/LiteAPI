//
//  LATemplate.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/26.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LATemplate.h"

@interface LATemplate ()

@property (nonatomic, strong) NSArray<NSMutableDictionary<LAIdentifier, id> *> *table;
@property (nonatomic, strong) NSMutableDictionary<LAIdentifier, NSNumber *> *status;

@end

@implementation LATemplate

#pragma mark - publics

- (void)registerTemplate:(id)template withIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status {
    self.table[status][identifier] = template;
}

- (id)templateWithIdentifier:(LAIdentifier)identifier {
    return [self templateWithIdentifier:identifier onStatus:[self statusForTemplate:identifier]];
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

- (void)setStatus:(LAStatus)status forTemplate:(LAIdentifier)identifier {
    self.status[identifier] = @(status);
}

- (LAStatus)statusForTemplate:(LAIdentifier)identifier {
    return self.status[identifier] ? [self.status[identifier] integerValue] : LAStatusProduction;
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
        self.status = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)description {
    __block NSMutableString *str = [NSMutableString stringWithString:@"\n"];
    [self.table enumerateObjectsUsingBlock:^(NSMutableDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *key in obj.keyEnumerator) {
            [str appendFormat:@"-------------------------API TEMPLATE[%@][%@]-------------------------\n", key, LAntoa(idx)];
            [str appendString:[obj[key] description]];
            [str appendFormat:@"-------------------------TEMPLATE END[%@][%@]-------------------------\n", key, LAntoa(idx)];
        }
    }];
    
    return str;
}


@end
