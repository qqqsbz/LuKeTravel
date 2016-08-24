//
//  XBPayUseCouponCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBCoupons;
@interface XBPayUseCouponCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UIImageView *chechMarkImageView;
@property (strong, nonatomic) IBOutlet UILabel *nouseLabel;
@property (strong, nonatomic) IBOutlet UIView *topSeparator;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparator;
@property (strong, nonatomic) IBOutlet UIView *contentSeparator;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

@property (strong, nonatomic) XBCoupons *coupons;
@end
