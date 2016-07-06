//
//  XBInviation.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBInviation : XBModel
@property (strong, nonatomic) NSString  *type;
@property (assign, nonatomic) BOOL      visable;
@property (strong, nonatomic) NSString  *imageUrl;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *subName;
@property (strong, nonatomic) NSString  *code;
@end