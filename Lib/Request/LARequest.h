//
//  LARequest.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/5.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADefine.h"

@interface LARequest : NSObject

@property (nonatomic, assign) BOOL synchronous;
@property (nonatomic, assign) LAResponseStyle responseStyle;
@property (nonatomic, assign) LAPostStyle postStyle;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSDictionary *param;                          //!< API parameters set by user

@end
