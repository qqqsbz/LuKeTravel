//
//  XBActivity.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBPackage;
@interface XBActivity : XBModel
@property (strong, nonatomic) NSString  *cityName;
@property (strong, nonatomic) NSString  *detail;
@property (assign, nonatomic) BOOL      isFavourite;
@property (strong, nonatomic) NSString  *latitude;
@property (strong, nonatomic) NSString  *longitude;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *subName;
@property (strong, nonatomic) NSArray<NSString *>   *images;
@property (strong, nonatomic) NSArray<XBPackage *>  *packages;
@end