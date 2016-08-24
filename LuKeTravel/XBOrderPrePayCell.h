//
//  XBOrderPrePayCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBOrderPrePayCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;
@property (strong, nonatomic) IBOutlet UIView *topSeparator;
@property (strong, nonatomic) IBOutlet UIView *contentSeparator;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparator;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;
@property (strong, nonatomic) IBOutlet UIImageView *paywayImageView;
@property (strong, nonatomic) IBOutlet UILabel *paywayLabel;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont  *textFont;
@end
