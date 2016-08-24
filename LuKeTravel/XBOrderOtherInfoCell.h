//
//  XBOrderOtherInfoCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBBookOtherInfo;
@interface XBOrderOtherInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;
@property (strong, nonatomic) IBOutlet UIView *topSeparator;
@property (strong, nonatomic) IBOutlet UIView *contentSeparator;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparator;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) XBBookOtherInfo *otherInfo;

/** 称谓第一响应者 */
@property (assign, nonatomic) BOOL  becomeFirstResponder;

/** 设置选择的内容 */
@property (strong, nonatomic) NSString *pickerString;
@end
