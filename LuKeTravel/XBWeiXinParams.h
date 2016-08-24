//
//  XBWeiXinParams.h
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBWeiXinParams : XBModel
@property (strong, nonatomic) NSString *sign;
@property (assign, nonatomic) long     timestamp;
@property (strong, nonatomic) NSString *noncestr;
@property (strong, nonatomic) NSString *partnerid;
@property (strong, nonatomic) NSString *prepayid;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *appid;
@end