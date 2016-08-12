//
//  XBArrangement.h
//  LuKeTravel
//
//  Created by coder on 16/8/11.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBArrangement : XBModel
@property (assign, nonatomic) BOOL      hasStock;
@property (strong, nonatomic) NSString  *startTime;
@end
