//
//  XBWeather.h
//  LuKeTravel
//
//  Created by coder on 16/7/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBWeather : XBModel
@property (strong, nonatomic) NSString  *type;
@property (assign, nonatomic) NSInteger temperature;
@end