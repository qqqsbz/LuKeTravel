//
//  XBOrderDetailViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderDetailViewController.h"
#import "XBBook.h"
#import "XBPayWay.h"
#import "XBPayContact.h"
#import "XBBookTicket.h"
#import "XBOrderDetailToolBar.h"
@interface XBOrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactEmailTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPhoneTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactEamilLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *payWayTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *payWayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *payWayImageView;
@property (strong, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSellLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalMarkerLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCouponTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCouponLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPayTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSaveLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

@property (strong, nonatomic) XBOrderDetailToolBar *toolBar;

@end

@implementation XBOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fillData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.toolBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.toolBar removeFromSuperview];
}

- (void)buildView
{
    self.title = [XBLanguageControl localizedStringForKey:@"order-detail-title"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 0, 30, 30);
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        
        constraint.constant = 0.5f;
    }
    
    UIView *keyView = self.navigationController.view;
    
    self.toolBar = [[XBOrderDetailToolBar alloc] initWithFrame:CGRectMake(0, keyView.xb_height - kOrderDetailBarHeight, keyView.xb_width, kOrderDetailBarHeight) payBlock:^{
        
        [self showToast:@"暂不支持支付!" inView:self.navigationController.view];
        
    }];
    
    self.toolBar.backgroundColor = [UIColor whiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kOrderDetailBarHeight, 0);
    
}

- (void)fillData
{
    XBBookTicket *bookTicket = [self.book.bookTickets firstObject];
    
    XBPayContact *contact = self.book.payContact;
    
    self.orderTitleLabel.text = bookTicket.packageDesc;
    
    self.orderDateLabel.text = self.dateString;
    
    self.contactTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-contact-title"];

    self.contactNameTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-contact-name"];
    
    self.contactEmailTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-contact-email"];

    self.contactPhoneTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-contact-phone"];
    
    self.totalTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-money-title"];
    
    self.totalAmountLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-money-total-title"];
    
    self.totalCouponTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-money-total-coupon"];
    
    self.totalPayTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-money-total-pay"];
    
    self.contactNameLabel.text = [NSString stringWithFormat:@"%@ %@",contact.firstName,contact.familyName];
    
    self.contactEamilLabel.text = contact.travellerEmail;
    
    self.contactPhoneLabel.text = [NSString stringWithFormat:@"+%@",contact.mobile];
    
    self.payWayTitleLabel.text = [XBLanguageControl localizedStringForKey:@"order-detail-payway-title"];
    
    self.payWayImageView.image = self.payWay.icon;
    
    self.payWayLabel.text = self.payWay.title;
    
    self.totalMarkerLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.marketPrice];
    
    self.totalSellLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.ticketPrice];
    
    self.totalCouponLabel.text = [NSString stringWithFormat:@"-%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],self.book.couponDiscount];
    
    self.totalPayLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],self.book.totalPrice];
    
    self.totalSaveLabel.text = [NSString stringWithFormat:@"%@%@ %@",[XBLanguageControl localizedStringForKey:@"order-detail-money-total-save"],[XBUserDefaultsUtil currentCurrencySymbol],self.book.totalSaving];
    
    self.totalCouponTitleLabel.hidden = [self.book.couponUsed clearBlack].length <= 0;
    
    self.totalCouponLabel.hidden = [self.book.couponUsed clearBlack].length <= 0;
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.totalMarkerLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    
    self.totalMarkerLabel.attributedText = attribtStr;
    
    NSString *tickTypeString = @"";
    
    for (NSString *ticketType in bookTicket.ticketTypeCounts) {
        
        tickTypeString = [tickTypeString stringByAppendingString:[NSString stringWithFormat:@"%@,",ticketType]];
    }
    
    self.orderCountLabel.text = [tickTypeString substringToIndex:tickTypeString.length - 1];
}

#pragma mark -- UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 3 && [self.book.couponUsed clearBlack].length <= 0) {
        
        height = height - 25.f;
    }
    
    return height;
}



- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
