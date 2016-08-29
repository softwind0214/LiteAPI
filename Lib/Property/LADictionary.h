//
//  LADictionary.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LAProperty.h"

@interface LADictionary : LAProperty

- (LAProperty *(^)(NSString *k, NSString *v))add;           //!< Add a pair of key and value to dictionary.

@end
