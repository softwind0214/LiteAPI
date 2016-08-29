//
//  LALocalRequestMaker.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/9/8.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADictionary.h"
#import "LACallback.h"
#import "LADefine.h"

@interface LALocalRequestMaker : NSObject

@property (nonatomic, readonly) LACallback *implement;

- (LALocalRequestMaker *(^)(NSString *value))scheme;                            //!< scheme of your API reqest
- (LALocalRequestMaker *(^)(NSString *value))host;                              //!< host of your API reqest
- (LALocalRequestMaker *(^)(NSString *value))path;                              //!< path of your API reqest

- (BOOL)match:(NSURL *)url;                                                     //!< check if the url is matched with self.

@end
