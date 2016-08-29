//
//  LARequestMaker+Persistant.h
//  LiteAPI
//
//  Created by Softwind Tang on 2016/12/23.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LARequestMaker.h"

@interface LARequestMaker (Persistant)

- (NSDictionary<NSString *, id> *)dictionaryRepresentation;
- (void)dictionaryLoad:(NSDictionary<NSString *, id> *)dic;

@end
