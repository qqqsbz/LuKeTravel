//
//  XBLevelOneSubName.h
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBMoreActivitySubNameItem;
@interface XBMoreActivitySubName : XBModel
@property (assign, nonatomic) NSInteger  selected;
@property (strong, nonatomic) NSArray<XBMoreActivitySubNameItem *>  *items;
@end
