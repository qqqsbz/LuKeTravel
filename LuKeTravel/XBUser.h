//
//  XBUser.h
//  LuKeTravel
//
//  Created by coder on 16/7/28.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBUser : XBModel <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSString      *userName;
@property (strong, nonatomic) NSString      *avatarUrl;
@property (assign, nonatomic) NSInteger     credits;
@property (strong, nonatomic) NSString      *currency;
@property (strong, nonatomic) NSString      *language;
@property (strong, nonatomic) NSString      *message;
@property (strong, nonatomic) NSString      *token;
@property (assign, nonatomic) NSInteger     validCoupons;
@end