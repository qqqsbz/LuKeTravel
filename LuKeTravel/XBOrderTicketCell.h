//
//  XBOrderConfirmBasicCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XBOrderTicketType){
    XBOrderTicketTypeTitle = 0,
    XBOrderTicketTypeFirstName,
    XBOrderTicketTypeFamily,
    XBOrderTicketTypeEmail,
    XBOrderTicketTypeCountryCode,
    XBOrderTicketTypePhone
};

@class XBBook;
@class XBOrderTicketCell;
@protocol XBOrderTicketCellDelegate <NSObject>

- (void)orderTicketCell:(XBOrderTicketCell *)orderTicketCell didSelectCountryCodeWithBook:(XBBook *)book;

@end
@interface XBOrderTicketCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldRightConstraints;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *verifityLabel;
@property (strong, nonatomic) IBOutlet UIView *pSeparatorView;
@property (strong, nonatomic) IBOutlet UIButton *pullButton;
@property (strong, nonatomic) IBOutlet UIView *topSeparator;
@property (strong, nonatomic) IBOutlet UIView *contentSeparator;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparator;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

/** cell的类型 */
@property (assign, nonatomic) XBOrderTicketType  type;
/** 数据 */
@property (strong, nonatomic) XBBook *book;
/** 代理 */
@property (weak, nonatomic) id<XBOrderTicketCellDelegate> delegate;
/** 称谓第一响应者 */
@property (assign, nonatomic) BOOL  orderTicketFirstResponder;
/** 设置选择框结果 */
@property (strong, nonatomic) NSString *pickerString;
@end
