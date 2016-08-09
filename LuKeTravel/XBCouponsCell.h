//
//  XBCouponsCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBCoupons;
@interface XBCouponsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *substanceView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *expireLabel;
@property (strong, nonatomic) XBCoupons *coupos;
@end
