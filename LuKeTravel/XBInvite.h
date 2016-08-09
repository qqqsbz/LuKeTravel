//
//  XBInvite.h
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBInvite : XBModel
@property (strong, nonatomic) NSString  *body;
@property (assign, nonatomic) BOOL      hasUsedCode;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *detail;
@property (strong, nonatomic) NSString  *referImage;
@property (strong, nonatomic) NSString  *referUrl;
@property (strong, nonatomic) NSString  *bonus;
@property (strong, nonatomic) NSString  *code;
@end
