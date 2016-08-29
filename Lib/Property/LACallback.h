//
//  LACallback.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LAProperty.h"

@interface LACallback : LAProperty

- (LACallback *(^)(id target, SEL selector))delegate;       //!< Define your callback with delegate.
- (LACallback *(^)(id (^)(id value)))block;                 //!< Define your callback with block.

- (id)invoke:(id)value;                                     //!< invoke this callback

@end
