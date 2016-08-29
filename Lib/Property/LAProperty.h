//
//  LAProperty.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAProperty : NSObject

@property (nonatomic, readonly) id property;                //!< data of this property

- (LAProperty *(^)(id value))set;                           //!< set this property with another LAProperty
- (LAProperty *(^)())clean;                                 //!< remove data of the property

@end