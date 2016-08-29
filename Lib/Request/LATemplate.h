//
//  LATemplate.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/26.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADefine.h"

@interface LATemplate : NSObject

+ (instancetype)shared;

#pragma mark - template S/L

- (void)registerTemplate:(id)template withIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status;
- (id)templateWithIdentifier:(LAIdentifier)identifier;
- (id)templateWithIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status;

#pragma mark - template traverse

- (NSArray *)allIdentifiers;
- (void)setStatus:(LAStatus)status forTemplate:(LAIdentifier)identifier;
- (LAStatus)statusForTemplate:(LAIdentifier)identifier;

@end
