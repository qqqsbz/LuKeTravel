//
//  XBGroupItem.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBGroupItem : XBModel
@property (strong, nonatomic) NSString  *type;
@property (strong, nonatomic) NSString  *imageUrl;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *subName;
@property (strong, nonatomic) NSString  *detail;
@property (strong, nonatomic) NSString  *cityName;
@property (strong, nonatomic) NSString  *currency;
@property (strong, nonatomic) NSString  *participants;
@property (strong, nonatomic) NSString  *marketPrice;
@property (strong, nonatomic) NSString  *sellingPrice;
@property (assign, nonatomic) BOOL      favorite;
@property (assign, nonatomic) BOOL      instant;
@property (assign, nonatomic) BOOL      video;
@end