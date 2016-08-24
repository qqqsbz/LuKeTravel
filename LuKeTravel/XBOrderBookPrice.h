//
//  XBOrderBookPrice.h
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBOrderBookPrice : XBModel
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) NSInteger marketPrice;
@property (assign, nonatomic) NSInteger maxNum;
@property (assign, nonatomic) NSInteger minNum;
@property (assign, nonatomic) NSInteger price;
@property (strong, nonatomic) NSString  *unitName;
@end