//
//  XBPackage.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBNotify;
@interface XBPackage : XBModel
@property (strong, nonatomic) NSString  *desc;
@property (strong, nonatomic) NSString  *detail;
@property (strong, nonatomic) NSString  *directionsAndLocation;
@property (assign, nonatomic) NSInteger marketPrice;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) NSInteger sellPrice;
@property (strong, nonatomic) NSString  *subName;
@property (strong, nonatomic) NSString  *termsAndConditions;
@property (strong, nonatomic) XBNotify  *notify;
@end
