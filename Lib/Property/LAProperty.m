//
//  LAProperty.m
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LAProperty.h"

@implementation LAProperty

- (void)setProperty:(id)property {
    
}

- (id)property {
    return nil;
}

- (LAProperty *(^)(id))set {    
    return ^id(id value) {
        self.property = value;
        return self;
    };
}

- (LAProperty *(^)())clean {
    return ^id(id value) {
        self.property = nil;
        return self;
    };
}

@end
