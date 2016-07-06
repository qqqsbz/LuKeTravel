//
//  XBComment.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBComment : XBModel
@property (strong, nonatomic) NSString  *content;
@property (strong, nonatomic) NSDate    *date;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) NSInteger rating;
@end