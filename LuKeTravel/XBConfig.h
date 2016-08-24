//
//  XBConfig.h
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBConfigSplash;
@class XBConfigCountry;
@interface XBConfig : XBModel
@property (strong, nonatomic) XBConfigCountry *firstCountryNumberEN;
@property (strong, nonatomic) XBConfigCountry *firstCountryNumberZHCN;
@property (strong, nonatomic) XBConfigCountry *firstCountryNumberZHTW;
@property (strong, nonatomic) XBConfigSplash *splashZhCN;
@property (strong, nonatomic) XBConfigSplash *splashZhTW;
@property (strong, nonatomic) XBConfigSplash *splashEN;

@end
