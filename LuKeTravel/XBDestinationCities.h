//
//  XBDestinationCities.h
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBDestinationItem;
@interface XBDestinationCities : XBModel
@property (assign, nonatomic) NSInteger  ID;
@property (strong, nonatomic) NSString  *regionName;
@property (strong, nonatomic) NSArray<XBDestinationItem *>  *items;
@end
