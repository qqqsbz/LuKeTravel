//
//  XBDestination.h
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBHotDestination;
@class XBDestinationCities;
@interface XBDestination : XBModel
@property (strong, nonatomic) NSArray<XBHotDestination *>       *popularDestinations;
@property (strong, nonatomic) NSArray<XBDestinationCities *>    *allCities;
@end
