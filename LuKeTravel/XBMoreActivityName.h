//
//  XBMoreActivityName.h
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBLevelOne;
@interface XBMoreActivityName : XBModel
@property (strong, nonatomic) NSString  *type;
@property (strong, nonatomic) NSString  *selected;
@property (strong, nonatomic) NSArray<XBLevelOne *>  *items;
@end
