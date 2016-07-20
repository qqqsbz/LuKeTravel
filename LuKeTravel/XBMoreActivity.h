//
//  XBMoreActivity.h
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBSearchItem;
@class XBMoreActivityName;
@class XBMoreActivitySubName;
@interface XBMoreActivity : XBModel
@property (strong, nonatomic) NSString                  *selectedTime;
@property (strong, nonatomic) NSString                  *sortType;
@property (strong, nonatomic) XBMoreActivityName        *name;
@property (strong, nonatomic) XBMoreActivitySubName     *subName;
@property (strong, nonatomic) NSArray<XBSearchItem *>   *items;
@end
