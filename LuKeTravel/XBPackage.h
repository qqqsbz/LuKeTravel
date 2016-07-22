//
//  XBPackage.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@interface XBPackage : XBModel
@property (assign, nonatomic) NSInteger marketPrice;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) NSInteger sellPrice;
@property (strong, nonatomic) NSString  *subName;
@end
