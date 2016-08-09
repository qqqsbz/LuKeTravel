//
//  XBWishlist.h
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@interface XBWishlist : XBModel
@property (strong, nonatomic) NSString  *currency;
@property (strong, nonatomic) NSString  *destinationName;
@property (strong, nonatomic) NSString  *hotState;
@property (assign, nonatomic) BOOL      isFavourite;
@property (assign, nonatomic) BOOL      isInstant;
@property (assign, nonatomic) BOOL      isVideo;
@property (assign, nonatomic) NSInteger marketPrice;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) NSInteger participants;
@property (strong, nonatomic) NSString  *participantsFormat;
@property (assign, nonatomic) NSInteger sellPrice;
@property (strong, nonatomic) NSString  *subName;
@property (strong, nonatomic) NSString  *thumbUrl;

@end

