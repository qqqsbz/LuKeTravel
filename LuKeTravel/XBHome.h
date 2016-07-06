//
//  XBHome.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBInviation;
@class XBGroup;
@interface XBHome : XBModel
@property (strong, nonatomic) NSString      *name;
@property (strong, nonatomic) NSString      *subName;
@property (strong, nonatomic) XBInviation   *inviation;
@property (strong, nonatomic) NSArray<XBGroup *>    *groups;
@property (strong, nonatomic) NSArray<NSString *>   *bannerImages;
@end
