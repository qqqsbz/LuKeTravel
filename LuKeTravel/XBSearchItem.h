//
//  XBSearchItem.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBSearchItem : XBModel
@property (strong, nonatomic) NSString      *type;
@property (strong, nonatomic) NSString      *name;
@property (assign, nonatomic) NSInteger     participants;
@property (assign, nonatomic) NSInteger     marketPrice;
@property (assign, nonatomic) NSInteger     sellingPrice;
@property (assign, nonatomic) BOOL          instant;
@property (assign, nonatomic) BOOL          video;
@property (assign, nonatomic) BOOL          favorite;
@property (strong, nonatomic) NSString      *hotState;
@property (strong, nonatomic) NSString      *participantsFormat;
@end
