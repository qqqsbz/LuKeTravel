//
//  XBBookOrderMoneyCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBookOrderMoneyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *saveLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorConstraint;

@end
