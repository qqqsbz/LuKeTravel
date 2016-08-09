//
//  XBUserInfo.h
//  LuKeTravel
//
//  Created by coder on 16/8/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBUserInfo : XBModel
@property (strong, nonatomic) NSString  *avatarUrl;
@property (strong, nonatomic) NSString  *city;
@property (strong, nonatomic) NSString  *country;
@property (strong, nonatomic) NSString  *familyName;
@property (strong, nonatomic) NSString  *firstName;
@property (strong, nonatomic) NSString  *mobile;
@property (assign, nonatomic) BOOL      mobileVerifyStatus;
@property (assign, nonatomic) BOOL      smsOpen;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *travellerEmail;
@end
