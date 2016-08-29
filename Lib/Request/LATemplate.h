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

@property (nonatomic, assign) LAStatus status;          //!< current API status

- (void)registerTemplate:(id)template withIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status;
- (id)templateWithIdentifier:(LAIdentifier)identifier;
- (id)templateWithIdentifier:(LAIdentifier)identifier onStatus:(LAStatus)status;

- (NSArray *)allIdentifiers;

+ (instancetype)shared;

@end
