//
//  XBGroup.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBGroupItem;
@interface XBGroup : XBModel
@property (strong, nonatomic) NSString  *className;
@property (strong, nonatomic) NSString  *type;
@property (strong, nonatomic) NSString  *displayType;
@property (strong, nonatomic) NSString  *displayText;
@property (strong, nonatomic) NSArray<XBGroupItem *>   *items;
@end
