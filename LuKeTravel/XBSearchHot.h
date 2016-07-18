//
//  XBSearchHot.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBSearch;
@interface XBSearchHot : XBModel <MTLManagedObjectSerializing>
@property (assign, nonatomic) NSInteger  cityCount;
@property (strong, nonatomic) NSArray<XBSearch *>  *items;
@end
