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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id)invoke:(id)value {
    if (self.procedure) {
        return self.procedure(value);
    } else {
        if ([self.target respondsToSelector:self.selector]) {
            return [self.target performSelector:self.selector withObject:value];
        }
    }
    
    return nil;
}

#pragma clang diagnostic pop

#pragma mark - getters/setters

- (void)setProperty:(id)property {
    LACallback *p = property;
    self.procedure = p.procedure;
    self.target = p.target;
    self.selector = p.selector;
}

#pragma mark - life cycle

- (NSString *)description {
    if (self.procedure) {
        return [NSString stringWithFormat:@"%@", self.procedure];
    } else if (self.target) {
        return [NSString stringWithFormat:@"[%@ %@]", self.target, NSStringFromSelector(self.selector)];
    }
    
    return nil;
}

@end
