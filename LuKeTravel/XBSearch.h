//
//  XBSearch.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBSearchItem;
@interface XBSearch : XBModel
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSArray<XBSearchItem *>  *values;
@end