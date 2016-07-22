//
//  XBNotify.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBNotify : XBModel
@property (strong, nonatomic) NSString  *address;
@property (strong, nonatomic) NSString  *confirmation;
@property (strong, nonatomic) NSString  *cancellation;
@property (strong, nonatomic) NSString  *duration;
@property (strong, nonatomic) NSString  *language;
@property (strong, nonatomic) NSString  *recommendedNumber;
@property (strong, nonatomic) NSString  *transportation;
@end