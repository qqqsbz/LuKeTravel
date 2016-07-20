//
//  XBMoreActivitySubNameCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBMoreActivitySort;
@interface XBMoreActivitySubNameCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkMarkButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorConstraint;

@property (strong, nonatomic) XBMoreActivitySort  *sort;

@end
