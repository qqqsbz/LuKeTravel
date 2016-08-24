//
//  XBBookOtherInfo.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBBookOtherInfo : XBModel
@property (strong, nonatomic) NSString  *content;
@property (assign, nonatomic) BOOL      dateFormat;
@property (assign, nonatomic) BOOL      listFormat;
@property (assign, nonatomic) NSInteger travelerNo;
@property (strong, nonatomic) NSString  *typeHint;
@property (assign, nonatomic) NSInteger typeId;
@property (strong, nonatomic) NSString  *typeName;
@end
