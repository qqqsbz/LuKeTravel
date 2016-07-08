//
//  XBCity.h
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBLevelOne;
@class XBGroup;
@interface XBCity : XBModel
@property (strong, nonatomic) NSString  *imageUrl;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSArray<XBLevelOne *>  *levelOnes;
@property (strong, nonatomic) NSArray<XBGroup *>     *groups;
@end
