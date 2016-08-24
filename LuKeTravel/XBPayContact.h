//
//  XBPayContact.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBPayContact : XBModel
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *familyName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *localContactNumber;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *pickupNeeded;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *travelCity;
@property (strong, nonatomic) NSString *travelCountry;
@property (strong, nonatomic) NSString *travellerEmail;
@end