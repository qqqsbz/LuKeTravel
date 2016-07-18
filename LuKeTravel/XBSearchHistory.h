//
//  XBSearchHistory.h
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBSearchHistory : XBModel <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSDate    *createdDate;
@end
