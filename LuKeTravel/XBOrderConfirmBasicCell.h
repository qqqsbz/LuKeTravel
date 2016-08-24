//
//  XBOrderConfirmBasicCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XBOrderCon) <#name#>
@interface XBOrderConfirmBasicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldRightConstraints;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *verifityLabel;
@property (strong, nonatomic) IBOutlet UIView *pSeparatorView;
@property (strong, nonatomic) IBOutlet UIButton *pullButton;
@property (strong, nonatomic) IBOutlet UIView *topSeparator;
@property (strong, nonatomic) IBOutlet UIView *contentSeparator;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparator;

@end
