//
//  XBOrderPrePayViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderPrePayViewController.h"
#import "XBBook.h"
#import "XBPayWay.h"
#import "XBCoupon.h"
#import "XBCoupons.h"
#import "XBPayContact.h"
#import "XBBookTicket.h"
#import "XBPayWayView.h"
#import "XBArrangement.h"
#import "XBOrderNextView.h"
#import "XBOrderPrePayCell.h"
#import "XBPayUseCouponView.h"
#import "XBOrderDetailTransition.h"
#import "XBOrderTicketHeaderCell.h"
#import "XBOrderPrePayTransition.h"
#import "XBOrderPrePayNavigationBar.h"
#import "XBOrderTicketViewController.h"
#import "XBOrderDetailViewController.h"
@interface XBOrderPrePayViewController () <XBPayWayViewDelegate,XBPayUseCouponViewDelegate,UIViewControllerTransitioningDelegate>
/** 支付方式选择 */
@property (strong, nonatomic) XBPayWayView *payWayView;
/** 兑换券选择 */
@property (strong, nonatomic) XBPayUseCouponView *payUseCouponView;
/** 选择的支付方式 */
@property (strong, nonatomic) XBPayWay *payWay;
@end
static NSString *const prepayReuseIdentifier = @"XBOrderPrePayCell";
static NSString *const headerReuseIdentifier = @"XBOrderTicketHeaderCell";
@implementation XBOrderPrePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self fillOrderTicketNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:self.orderPrePayNavigationBar];
    
    self.navigationItem.hidesBackButton = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.orderPrePayNavigationBar removeFromSuperview];
    
    self.navigationItem.hidesBackButton = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    [self hideLoading];
    
}

- (void)buildView
{
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderTicketHeaderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:headerReuseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderPrePayCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:prepayReuseIdentifier];
    
    XBOrderNextView *nextView = [[XBOrderNextView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.xb_width, 86) nextBlock:^{
        
        [self showOrderDetail];
        
    }];
    
    nextView.title = [XBLanguageControl localizedStringForKey:@"activity-order-prepay-topay"];
    
    nextView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = nextView;
    
    self.orderPrePayNavigationBar = [[XBOrderPrePayNavigationBar alloc] initWithFrame:CGRectMake(kSpace, 0, self.view.xb_width - kSpace * 2, 90.f) popBlock:^{
        
        [self updateTicket];
        
    }];
    
    self.orderPrePayNavigationBar.backgroundColor = [UIColor whiteColor];
    
    self.orderPrePayNavigationBar.layer.masksToBounds = YES;
    
    self.orderPrePayNavigationBar.layer.cornerRadius  = 5.f;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.payWayView = [[XBPayWayView alloc] initWithFrame:keyWindow.bounds];
    
    self.payWayView.delegate = self;
    
    [keyWindow addSubview:self.payWayView];
    
    self.payUseCouponView = [[XBPayUseCouponView alloc] initWithFrame:keyWindow.bounds];
    
    self.payUseCouponView.coupons = self.book.coupons;
    
    self.payUseCouponView.delegate = self;
    
    [keyWindow addSubview:self.payUseCouponView];
}

- (void)fillOrderTicketNavigationBar
{
    XBBookTicket *bookTicket = [self.book.bookTickets firstObject];
    
    self.orderPrePayNavigationBar.titleLabel.text = bookTicket.packageDesc;
    
    self.orderPrePayNavigationBar.markerLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.marketPrice];
    
    self.orderPrePayNavigationBar.sellLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.ticketPrice];
    
    self.orderPrePayNavigationBar.contactNameLabel.text = [[XBLanguageControl localizedStringForKey:@"activity-order-contact-name"] stringByAppendingString:[NSString stringWithFormat:@"%@ %@",self.book.payContact.familyName,self.book.payContact.firstName]];
    
    self.orderPrePayNavigationBar.contactPhoneLabel.text = [NSString stringWithFormat:@"%@+%@",[XBLanguageControl localizedStringForKey:@"activity-order-contact-phone"],self.book.payContact.mobile];
    
    self.orderPrePayNavigationBar.contactEmailLabel.text = [[XBLanguageControl localizedStringForKey:@"activity-order-contact-name"] stringByAppendingString:self.book.payContact.travellerEmail];
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.orderPrePayNavigationBar.markerLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    
    self.orderPrePayNavigationBar.markerLabel.attributedText = attribtStr;
    
    NSString *count = @"";
    
    for (NSString *ticket in bookTicket.ticketTypeCounts) {
        
        count = [count stringByAppendingString:[NSString stringWithFormat:@"%@,",ticket]];
        
    }
    
    self.orderPrePayNavigationBar.countLabel.text = [count substringToIndex:count.length - 1];
    
    
    NSArray *dateStrings = [[[bookTicket.arrangement.startTime componentsSeparatedByString:@"T"] firstObject] componentsSeparatedByString:@"-"];
    
    NSString *dateString = @"";
    
    if (![[XBUserDefaultsUtil currentLanguage] isEqualToString:kLanguageENUS]) {
        
        dateString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-ticket-date"],[dateStrings firstObject],dateStrings[1],[dateStrings lastObject]];
        
    } else {
        
        dateString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-date"],[NSString monthOfStringForENUS:[dateStrings[1] integerValue]],[dateStrings lastObject],[dateStrings firstObject]];
        
    }
    
    self.orderPrePayNavigationBar.dateLabel.text = dateString;
}

#pragma mark -- UITable view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        XBOrderTicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        
        cell.titleLabel.text = indexPath.section == 0 ? [XBLanguageControl localizedStringForKey:@"activity-order-prepay-option-title"] : [XBLanguageControl localizedStringForKey:@"activity-order-prepay-total"];

        return cell;
    }
    
    XBOrderPrePayCell * cell = [tableView dequeueReusableCellWithIdentifier:prepayReuseIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.textColor = cell.textColor;
    
    if (indexPath.section == 0) {
        
        cell.topSeparator.hidden = NO;
        
        cell.bottomSeparator.hidden = NO;
        
        cell.contentSeparator.hidden = YES;
        
        cell.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-prepay-option"];
        
        cell.rightImageView.hidden = NO;
        
        cell.detailLabel.hidden = YES;
        
    } else {
        
        cell.topSeparator.hidden = YES;
        
        cell.contentSeparator.hidden = indexPath.row == 2;
        
        cell.bottomSeparator.hidden = indexPath.row == 1;
        
        cell.titleLabel.text = indexPath.row == 1 ? [XBLanguageControl localizedStringForKey:@"activity-order-prepay-coupon"] : [XBLanguageControl localizedStringForKey:@"activity-order-prepay-pay"];
        
        cell.titleLabel.textColor = indexPath.row == 1 ? cell.textColor : [UIColor blackColor];
        
        cell.titleLabel.font = indexPath.row == 1 ? cell.textFont : [UIFont boldSystemFontOfSize:15.f];
        
        cell.rightImageView.hidden = indexPath.row != 1;
        
        cell.detailLabel.hidden = indexPath.row == 1;
        
        cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],self.book.totalPrice];
    }
    
    //设置支付方式
    if (indexPath.row == 1 && indexPath.section == 0 && self.payWay) {
        
        cell.paywayLabel.text = self.payWay.title;
        
        cell.paywayImageView.image = self.payWay.icon;
        
        cell.titleLabel.hidden = YES;
        
        cell.paywayImageView.hidden = NO;
        
        cell.paywayLabel.hidden = NO;
    
    } else if (indexPath.section == 1 && indexPath.row == 1 && [self.book.couponUsed clearBlack].length > 0) {
        
        cell.detailLabel.text = [NSString stringWithFormat:@"-%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],self.book.couponDiscount];
        
        cell.detailLabel.textColor = cell.textColor;
        
        cell.detailLabel.font = cell.titleLabel.font;
        
        cell.detailLabel.hidden = NO;
        
        cell.rightImageView.hidden = YES;
    }
    
    return cell;
}


#pragma mark -- UITable delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 50 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        [self.payWayView toggle];
    
    } else if (indexPath.section == 1 && indexPath.row == 1) {
     
        [self.payUseCouponView toggle];
    }
}

#pragma mark -- XBPayWayViewDelegate
- (void)payWayView:(XBPayWayView *)payWayView didSelectWithPayWay:(XBPayWay *)payWay
{
    [self showLoadinngInView:[self.payWayView payWayContentView]];
    
    [[XBHttpClient shareInstance] postPayTypeWithTicketId:[[self.book.bookTickets firstObject].modelId integerValue] gateWay:payWay.payWay creditCardNumber:@"" creditCardToken:@"" success:^(XBBook *book) {
        
        [payWayView toggle];
        
        book.payContact = self.book.payContact;
        
        self.book = book;
        
        self.payWay = payWay;
        
        [self.tableView reloadData];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
    }];
}


#pragma mark -- XBPayUseCouponViewDelegate
- (void)payUseCouponView:(XBPayUseCouponView *)payUseCouponView didSelectCouponWithCoupons:(XBCoupons *)coupons
{
    [self showLoadinngInView:[self.payUseCouponView payUseContentView]];
    
    [[XBHttpClient shareInstance] useCouponWithTicketId:[[self.book.bookTickets firstObject].modelId integerValue] promotionCode:coupons.code success:^(XBBook *book) {
        
        book.payContact = self.book.payContact;
        
        self.book = book;
        
        [self.tableView reloadData];
        
        [payUseCouponView toggle];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *errorMsg = [error.userInfo valueForKey:kErrorMessage];
        
        errorMsg = errorMsg.length > 0 ? errorMsg : [XBLanguageControl localizedStringForKey:@"error-no-network-signal"];
        
        [self showAlertWithTitle:errorMsg];
        
    }];
}

- (void)payUseCouponView:(XBPayUseCouponView *)payUseCouponView didSelectRedeemWithCode:(NSString *)code
{
    if ([code clearBlack].length <= 0) return;
    
    [self showLoadinngInView:[payUseCouponView payUseContentView]];
    
    [[XBHttpClient shareInstance] postCouponsWithCouponCode:code success:^(XBCoupon *coupon) {
        
        self.book.coupons = coupon.coupons;
        
        self.payUseCouponView.coupons = coupon.coupons;
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *errorMsg = [error.userInfo valueForKey:kErrorMessage];
        
        errorMsg = errorMsg.length > 0 ? errorMsg : [XBLanguageControl localizedStringForKey:@"error-no-network-signal"];
        
        [self showToast:errorMsg inView:[payUseCouponView payUseContentView]];
        
    }];
}

/** 更新订单 */
- (void)updateTicket
{
    
    [self showLoadinng];
    
    [[XBHttpClient shareInstance] updateTicketWithTicketId:[[self.book.bookTickets firstObject].modelId integerValue] success:^(XBBook *book) {
        
        NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController childViewControllers]];
        
        [viewControllers removeLastObject];
        
        if ([[viewControllers lastObject] isKindOfClass:[XBOrderTicketViewController class]]) {
            
            XBOrderTicketViewController *orderTicketVC = (XBOrderTicketViewController *)[viewControllers lastObject];
            
            book.payContact = self.book.payContact;
            
            orderTicketVC.book = book;
            
//            orderTicketVC.navigationController.delegate = self;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [self hideLoading];
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [self showAlertWithTitle:[XBLanguageControl localizedStringForKey:@"error-no-network-signal"]];
    }];
}


- (void)showOrderDetail
{
    if (!self.payWay) {
        
        [self showToast:[XBLanguageControl localizedStringForKey:@"activity-order-prepay-none-payoption"]];
        
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    XBOrderDetailViewController *orderDetailVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([XBOrderDetailViewController class])];
    
    orderDetailVC.book = self.book;
    
    orderDetailVC.payWay = self.payWay;
    
    orderDetailVC.dateString = self.orderPrePayNavigationBar.dateLabel.text;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:orderDetailVC];
    
    navigationController.transitioningDelegate = self;

    [self presentViewController:navigationController animated:YES completion:nil];
    
}

/** 转场动画 push */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    NSString *fromVCString = NSStringFromClass([fromVC class]);
    
    NSString *toVCString = NSStringFromClass([toVC class]);
    
    if (([fromVCString isEqualToString:NSStringFromClass([XBOrderTicketViewController class])] && [toVCString isEqualToString:NSStringFromClass([XBOrderPrePayViewController class])]) || ([fromVCString isEqualToString:NSStringFromClass([XBOrderPrePayViewController class])] && [toVCString isEqualToString:NSStringFromClass([XBOrderTicketViewController class])])) {
        
        return [XBOrderPrePayTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBOrderPrePayTransitionTypePush : XBOrderPrePayTransitionTypePop];
        
    }
    
    return nil;
}

/** 转场动画 present */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [XBOrderDetailTransition transitionWithTransitionType:XBOrderDetailTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [XBOrderDetailTransition transitionWithTransitionType:XBOrderDetailTransitionTypeDismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
