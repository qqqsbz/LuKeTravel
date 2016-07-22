//
//  XBActivity.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBPackage;
@class XBNotify;
@class XBShareActivity;
@interface XBActivity : XBModel
@property (strong, nonatomic) NSString  *cityName;
@property (strong, nonatomic) NSString  *desc;
@property (strong, nonatomic) NSString  *detail;
@property (strong, nonatomic) NSString  *directionsAndLocation;
@property (strong, nonatomic) NSString  *frequentlyAskedQuestions;
@property (strong, nonatomic) NSString  *hotState;
@property (assign, nonatomic) BOOL      isFavourite;
@property (assign, nonatomic) BOOL      isInstant;
@property (strong, nonatomic) NSString  *latitude;
@property (strong, nonatomic) NSString  *longitude;
@property (assign, nonatomic) NSInteger marketPrice;
@property (assign, nonatomic) NSInteger sellPrice;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *subName;
@property (assign, nonatomic) NSInteger participants;
@property (strong, nonatomic) NSString  *participantsFormat;
@property (assign, nonatomic) float     rating;
@property (strong, nonatomic) NSString  *recommend;
@property (assign, nonatomic) NSInteger reviewsCount;
@property (strong, nonatomic) NSString  *termsAndConditions;
@property (strong, nonatomic) NSString  *videoUrl;
@property (strong, nonatomic) XBNotify  *notify;
@property (strong, nonatomic) XBShareActivity       *shareActivity;
@property (strong, nonatomic) NSArray<NSString *>   *images;
@property (strong, nonatomic) NSArray<XBPackage *>  *packages;
@end