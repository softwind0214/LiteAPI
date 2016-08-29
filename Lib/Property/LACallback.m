//
//  LACallback.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LACallback.h"

@interface LACallback ()

@property (nonatomic, strong) id (^procedure)(id value);

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) LAThread preferThread;
@property (nonatomic, assign) BOOL waitForResult;

@end

@implementation LACallback

- (LACallback *(^)(id (^)(id)))block {
    return ^id(id (^procedure)(id value)) {
        self.procedure = [procedure copy];
        return self;
    };
}

- (LACallback *(^)(id, SEL))delegate {
    return ^id(id target, SEL selector) {
        self.target = target;
        self.selector = selector;
        return self;
    };
}

- (LACallback *(^)(LAThread))thread {
    return ^id(LAThread value) {
        self.preferThread = value;
        return self;
    };
}

- (LACallback *(^)(BOOL))wait {
    return ^id(BOOL value) {
        self.waitForResult = value;
        return self;
    };
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id)invoke:(id)value {
    switch (self.preferThread) {
        case LAThreadMain:
            return [self invokeMain:value];
            
        case LAThreadBackground:
            return [self invokeBackground:value];
            
        case LAThreadCurrent:
        default:
            return [self invokeDirect:value];
    }
    return nil;
}

- (id)proceed:(id)value {
    if (self.procedure) {
        return self.procedure(value);
    }
    if ([self.target respondsToSelector:self.selector]) {
        return [self.target performSelector:self.selector
                                 withObject:value];
    }
    return nil;
}

#pragma mark - thread

- (id)invokeMain:(id)value {
    if ([NSThread currentThread].isMainThread) {
        return [self proceed:value];
    } else if (!self.waitForResult) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceed:value];
        });
        return nil;
    } else {
        __block dispatch_semaphore_t s = dispatch_semaphore_create(0);
        __block id result = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            result = [self proceed:value];
            dispatch_semaphore_signal(s);
        });
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        return result;
    }
}

- (id)invokeBackground:(id)value {
    if (![NSThread currentThread].isMainThread) {
        return [self proceed:value];
    } else if (!self.waitForResult){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self proceed:value];
        });
        return nil;
    } else {
        __block dispatch_semaphore_t s = dispatch_semaphore_create(0);
        __block id result = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            result = [self proceed:value];
            dispatch_semaphore_signal(s);
        });
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        return result;
    }
}

- (id)invokeDirect:(id)value {
    return [self proceed:value];
}

#pragma clang diagnostic pop

#pragma mark - getters/setters

- (void)setProperty:(id)property {
    LACallback *p = property;
    self.procedure = p.procedure;
    self.target = p.target;
    self.selector = p.selector;
    self.preferThread = p.preferThread;
    self.waitForResult = p.waitForResult;
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.preferThread = LAThreadCurrent;
        self.waitForResult = YES;
    }
    return self;
}

- (NSString *)description {
    if (self.procedure) {
        return [NSString stringWithFormat:@"%@", self.procedure];
    } else if (self.target) {
        return [NSString stringWithFormat:@"[%@ %@]", self.target, NSStringFromSelector(self.selector)];
    }
    
    return nil;
}

@end
