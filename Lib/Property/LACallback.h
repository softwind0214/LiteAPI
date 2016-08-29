//
//  LACallback.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LAProperty.h"
#import "LADefine.h"

@interface LACallback : LAProperty

#pragma mark - procedure

- (LACallback *(^)(id target, SEL selector))delegate;       //!< Define your callback with delegate.
- (LACallback *(^)(id (^)(id value)))block;                 //!< Define your callback with block.

#pragma mark - thread

/**
 *  Define on which thread you want to invoke the callback.
 *  Default LAThreadCurrent. That means callback will be invoked on current thread.
 */
- (LACallback *(^)(LAThread value))thread;

/**
 *  Define whether the current thread will wait for result. Default YES.
 */
- (LACallback *(^)(BOOL value))wait;

- (id)invoke:(id)value;                                     //!< invoke this callback

@end
