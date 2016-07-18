//
//  XBHomeSearchActivityClickCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBSearchItem;
@interface XBHomeSearchActivityClickCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *substanceView;
@property (strong, nonatomic) IBOutlet UIImageView   *coverImageView;
@property (strong, nonatomic) IBOutlet UIImageView   *favoriteImageView;
@property (strong, nonatomic) IBOutlet UIView        *pirceView;
@property (strong, nonatomic) IBOutlet UILabel       *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel       *sellingPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel       *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *instantImageView;
@property (strong, nonatomic) IBOutlet UILabel       *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *addressImageView;
@property (strong, nonatomic) IBOutlet UILabel       *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *participantsImageView;
@property (strong, nonatomic) IBOutlet UILabel       *participantsLabel;

@property (strong, nonatomic) XBSearchItem  *groupItem;

@end
