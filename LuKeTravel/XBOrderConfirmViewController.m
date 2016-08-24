//
//  XBOrderConfirmViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderConfirmViewController.h"
#import "XBBook.h"
#import "XBExchange.h"
#import "XBBookTicket.h"
#import "XBPayContact.h"
#import "XBPickerView.h"
#import "RegexKitLite.h"
#import "NSString+Util.h"
#import "XBCountryView.h"
#import "XBArrangement.h"
#import "XBBookOtherInfo.h"
#import "XBOrderConfirmTransition.h"
#import "XBBookOrderViewController.h"
#import "XBOrderConfirmNavigationBar.h"
#import "XBOrderCalendarViewController.h"
@interface XBOrderConfirmViewController () <XBPickerViewDatasource,XBPickerViewDelegate,UIGestureRecognizerDelegate>
/** 称谓文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *appellationLabel;
/** 称谓 */
@property (strong, nonatomic) IBOutlet UILabel *appellationTextField;
/** 名字文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
/** 名字输入框 */
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
/** 姓氏文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *familyLabel;
/** 姓氏输入框 */
@property (strong, nonatomic) IBOutlet UITextField *familyTextField;
/** 邮箱文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
/** 邮箱输入框 */
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
/** 国家代码文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
/** 国家代码输入框 */
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
/** 电话号码文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
/** 电话号码输入框 */
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
/** 出行人基本信息 */
@property (strong, nonatomic) IBOutlet UILabel *basicLabel;
/** 下一步按钮 */
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
/** 电话号码输入框距离父view右边的距离 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *phoneRightConstraint;
/** 已验证文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *verifiedLabel;
/** 特别信息 */
@property (strong, nonatomic) IBOutlet UILabel *specialBasicLabel;
/** 特别信息标题 */
@property (strong, nonatomic) IBOutlet UILabel *specialTitleLabel;
/** 特别信息详细 */
@property (strong, nonatomic) IBOutlet UITextField *specialDetailTextField;
/** 所有的分割线 */
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

/** 国家代码 */
@property (strong, nonatomic) NSString      *code;
/** 选择框 */
@property (strong, nonatomic) XBPickerView  *pickerView;
/** 当前选中的输入框 */
@property (strong, nonatomic) NSIndexPath   *currentIndexPath;

/** 称谓数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *appellations;
/** 国家数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *countries;
/** 临时数据 用于切换 称谓、国家之间的数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *datas;

@end

@implementation XBOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fill];
    
    [self buildView];
    
    [self reloadLanguageConfig];
    
    [self fillOrderConfirmNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.view addSubview:self.orderConfirmNavigationBar];
 
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.orderConfirmNavigationBar removeFromSuperview];
    
    self.navigationItem.hidesBackButton = NO;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
}


- (void)reloadLanguageConfig
{
    
    if (self.book) {
        
        XBPayContact *contact = self.book.payContact;
        
        self.nameTextField.text = contact.firstName;
        
        self.familyTextField.text = contact.familyName;
        
        self.emailTextField.text = contact.travellerEmail;
        
        self.nextButton.enabled = contact != nil;
        
        self.appellationTextField.text = contact.title.length > 0 ? contact.title : [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"];
        
        //如果已经设置了称谓则修改字体颜色
        self.appellationTextField.textColor = [contact.title clearBlack].length > 0 ? [UIColor blackColor] : self.appellationTextField.textColor;
        
        //手机号码已验证
        if (self.book.mobileVerifyStatus) {
            
            NSArray *numbers = [contact.mobile componentsSeparatedByString:@"-"];
            
            self.verifiedLabel.hidden = NO;
            
            self.code = [numbers firstObject];
            
            self.codeTextField.text = [NSString stringWithFormat:@"+%@",[numbers firstObject]];
            
            self.phoneTextField.text = [numbers lastObject];
            
            self.phoneRightConstraint.constant = self.view.xb_width - self.verifiedLabel.xb_x;
            
        }
        
        //设置其他信息
        if ([self.book.bookTickets firstObject].generalOtherInfos.count > 0) {
            
            XBBookOtherInfo *otherInfo = [[self.book.bookTickets firstObject].generalOtherInfos firstObject];
            
            self.specialTitleLabel.text = otherInfo.typeName;
            
            self.specialDetailTextField.placeholder = otherInfo.typeHint;
            
            self.specialDetailTextField.text = otherInfo.content;
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.tableView.contentSize = CGSizeMake(self.tableView.xb_width, self.tableView.contentSize.height + 120);
            });
            
        }
        
        self.view.userInteractionEnabled = YES;
        
    } else {
        
        UIFont *font = self.appellationTextField.font;
        
        UIColor *textColor = self.appellationTextField.textColor;
        
        self.appellationTextField.text = [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"];
        
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-name-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        
        self.familyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-family-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-email-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        
        self.codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-code-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        
        self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-phone-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        
    }
    
    self.basicLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-basic"];
    
    self.specialBasicLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-special"];
    
    self.appellationLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-appellation"];

    self.familyLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-family"];
    
    self.nameLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-name"];
    
    self.emailLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-email"];
    
    self.codeLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-code"];
    
    self.phoneLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-phone"];
    
    self.verifiedLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-code-verified"];
    
    [self.nextButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-order-next"] forState:UIControlStateNormal];
}

- (void)fill
{
    self.verifiedLabel.hidden = YES;
    
    self.nextButton.layer.masksToBounds = YES;
    
    self.nextButton.layer.cornerRadius  = 5.f;
    
    self.phoneRightConstraint.constant = self.view.xb_width - self.verifiedLabel.xb_maxX;
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        
        constraint.constant = 0.5f;
        
    }
    
    self.appellations = @[
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-chose"] text:@"" desc:nil],
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mr"] text:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mr"] desc:nil],
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mrs"] text:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mrs"] desc:nil],
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-miss"] text:[XBLanguageControl localizedStringForKey:@"user-info-appellation-miss"] desc:nil]
                          ];
    
    //获取语言
    NSString *countryPath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    
    self.countries = [XBExchange exchangeFromArray:[NSArray arrayWithContentsOfFile:countryPath]];
    
}

- (void)buildView
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.pickerView = [[XBPickerView alloc] initWithFrame:keyWindow.bounds];
    
    self.pickerView.datasource = self;
    
    self.pickerView.delegate = self;
    
    self.pickerView.hideTitle = YES;
    
    self.pickerView.hideCancle = YES;
    
    self.pickerView.pickerColor = [UIColor colorWithHexString:@"#D0D5DA"];
    
    self.pickerView.backgroundColor = [UIColor clearColor];
    
    self.pickerView.navigationBarColor = [UIColor colorWithHexString:@"#E7E7E7"];
    
    [keyWindow addSubview:self.pickerView];
    
    self.orderConfirmNavigationBar = [[XBOrderConfirmNavigationBar alloc] initWithFrame:CGRectMake(kSpace, 0, self.view.xb_width - kSpace * 2, 90.f) popBlock:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    self.orderConfirmNavigationBar.layer.shadowColor = [UIColor redColor].CGColor;
    
    self.orderConfirmNavigationBar.layer.shadowOffset = CGSizeMake(200,200);
    
    self.orderConfirmNavigationBar.layer.shadowOpacity = 1;//阴影透明度，默认0
    
    self.orderConfirmNavigationBar.layer.shadowRadius = 150;//阴影半径，默认3
    
    self.orderConfirmNavigationBar.backgroundColor = [UIColor whiteColor];
    
    self.orderConfirmNavigationBar.layer.masksToBounds = YES;
    
    self.orderConfirmNavigationBar.layer.cornerRadius  = 5.f;
    
//    self.orderConfirmNavigationBar.layer.shadowColor = [UIColor colorWithHexString:@"#E1E1E1"].CGColor;
    
}

- (void)fillOrderConfirmNavigationBar
{
    XBBookTicket *bookTicket = [self.book.bookTickets firstObject];
    
    self.orderConfirmNavigationBar.titleLabel.text = bookTicket.packageDesc;
    
    self.orderConfirmNavigationBar.markerLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.marketPrice];
    
    self.orderConfirmNavigationBar.sellLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.ticketPrice];
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.orderConfirmNavigationBar.markerLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    
    self.orderConfirmNavigationBar.markerLabel.attributedText = attribtStr;
    
    NSString *count = @"";
    
    for (NSString *ticket in bookTicket.ticketTypeCounts) {
        
        count = [count stringByAppendingString:[NSString stringWithFormat:@"%@,",ticket]];
        
    }
    
    self.orderConfirmNavigationBar.countLabel.text = [count substringToIndex:count.length - 1];
    
    
    NSArray *dateStrings = [[[bookTicket.arrangement.startTime componentsSeparatedByString:@"T"] firstObject] componentsSeparatedByString:@"-"];
    
    NSString *dateString = @"";
    
    if (![[XBUserDefaultsUtil currentLanguage] isEqualToString:kLanguageENUS]) {
        
        dateString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-ticket-date"],[dateStrings firstObject],dateStrings[1],[dateStrings lastObject]];
        
    } else {
        
        dateString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-date"],[self monthOfStringForENUS:[dateStrings[1] integerValue]],[dateStrings lastObject],[dateStrings firstObject]];
        
    }

    self.orderConfirmNavigationBar.dateLabel.text = dateString;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7 && [self.book.bookTickets firstObject].generalOtherInfos.count <= 0) {
        
        return 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 1) {
        
        self.currentIndexPath = indexPath;
        
        if (!self.pickerView.isShow) {
            
            [self.pickerView toggle];
        }
        
        //防止键盘挡住选择框
        [self.view endEditing:YES];
        
        self.datas = self.appellations;
        
        [self.pickerView reloadData];
        
    } else if (indexPath.row == 2) {
        
        [self.nameTextField becomeFirstResponder];
        
    } else if (indexPath.row == 3) {
        
        [self.familyTextField becomeFirstResponder];
        
    } else if (indexPath.row == 4) {
        
        [self.emailTextField becomeFirstResponder];
        
    } else if (indexPath.row == 5) {
        
        [self.codeTextField becomeFirstResponder];
        
    } else if (indexPath.row == 6) {
        
        [self.phoneTextField becomeFirstResponder];
        
    }
}

#pragma mark -- XBPickerViewDatasource
- (NSInteger)numberOfComponentsInXBPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)xbPickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.datas.count;
}

#pragma mark -- XBPickerViewDelegate
- (UIView *)xbPickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    XBExchange *change = self.datas[row];
    
    if (self.currentIndexPath.row == 1) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        titleLabel.text = [XBLanguageControl localizedStringForKey:change.title];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        
        return titleLabel;
    }
    
    XBCountryView *countryView = [[XBCountryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.pickerView.frame), 35.f)];
    
    countryView.imageView.image = [UIImage imageNamed:change.desc];
    
    countryView.titleLabel.text = [XBLanguageControl localizedStringForKey:change.text];
    
    return countryView;
    
}

- (CGFloat)xbPickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.f;
}

- (void)xbPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    XBExchange *change = self.datas[row];
    
    if (self.currentIndexPath.row == 1) {
        
        self.appellationTextField.text = row == 0 ? [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"] : change.text;
        
        self.appellationTextField.textColor = row == 0 ? [UIColor colorWithHexString:@"#B3B2BA"] : [UIColor blackColor];
        
    } else if (self.currentIndexPath.row == 5) {
        
        self.code = change.text;
        
        self.codeTextField.text = [NSString stringWithFormat:@"+%@",change.text];
        
    }
}


- (IBAction)codeAction:(UIButton *)sender {
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    
    if (!self.pickerView.isShow) {
        
        [self.pickerView toggle];
    }
    
    //防止键盘挡住选择框
    [self.view endEditing:YES];
    
    self.datas = self.countries;
    
    [self.pickerView reloadData];
}


- (IBAction)nextAction:(UIButton *)sender {

    NSString *appellation = [self.appellationTextField.text clearBlack];
    
    NSString *name = [self.nameTextField.text clearBlack];
    
    NSString *family = [self.familyTextField.text clearBlack];
    
    NSString *email = [self.emailTextField.text clearBlack];
    
    NSString *code = [self.codeTextField.text clearBlack];
    
    NSString *phone = [self.phoneTextField.text clearBlack];
    
    NSRange emailRange = [email rangeOfRegex:kEmailRegex];
    
    if (name.length <= 0 || family.length <= 0 || email.length <= 0 || code.length <= 0 || phone.length <= 0 || [appellation isEqualToString:[XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"]]) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-error-all-field"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"user-info-logout-confirm"], nil];
        
        [alertView show];
        
        return;
        
    } else if (emailRange.location == NSNotFound) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"login-alert-message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"login-alert-confirm"], nil];
        [alertView show];
        
        return;
    }
    
    XBPayContact *payContact = self.book.payContact;
    
    payContact.firstName = name;
    
    payContact.familyName = family;
    
    payContact.title = appellation;
    
    payContact.email = email;
    
    payContact.mobile = [NSString stringWithFormat:@"%@-%@",self.code,phone];
    
    NSInteger ticketId = [[self.book.bookTickets firstObject].modelId integerValue];
    
    NSString *otherInfoString = @"";
    
    if ([self.book.bookTickets firstObject].generalOtherInfos.count > 0) {
        
        XBBookOtherInfo *otherInfo = [[self.book.bookTickets firstObject].generalOtherInfos firstObject];
        
        otherInfo.content = [self.specialDetailTextField.text clearBlack];
        
        NSArray *array = [MTLJSONAdapter JSONArrayFromModels:[self.book.bookTickets firstObject].generalOtherInfos];
        
        NSError *error;
        
        NSData *data;
        
        for (NSDictionary *dic in array) {
            
            data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            
            otherInfoString = [otherInfoString stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            
            otherInfoString = [otherInfoString stringByAppendingString:@","];
            
        }
        
        otherInfoString = [otherInfoString substringToIndex:otherInfoString.length - 1];
        
        DDLogDebug(@"array:%@",array);
        
    }
    
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] payTypeWithPayContact:payContact ticketId:ticketId otherInfo:otherInfoString success:^(XBBook *book) {
        
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *errorMsg = @"";
        
        if (error.code == kPhoneErrorUsedCode || error.code == kOrderUnExistCode) {
            
            errorMsg = [error.userInfo valueForKey:kErrorMessage];
            
        } else {
            
            errorMsg = [XBLanguageControl localizedStringForKey:@"error-no-network-signal"];
        }
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:errorMsg message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"login-alert-confirm"], nil];
        
        [alertView show];

    }];

}


#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField) {
        
        NSString *text = [[NSString stringWithFormat:@"%@%@",textField.text,string] clearBlack];
        
        text = [string isEqualToString:@""] ? [text substringToIndex:text.length - 1] : text;
        
        NSString *phone = [[self.book.payContact.mobile componentsSeparatedByString:@"-"] lastObject];
        
        if ([phone isEqualToString:text]) {
            
            self.verifiedLabel.hidden = NO;
            
            self.phoneRightConstraint.constant = self.view.xb_width - self.verifiedLabel.xb_x;
            
        } else {
            
            self.verifiedLabel.hidden = YES;
            
            self.phoneRightConstraint.constant = 10.;
        }
        
    }
    return YES;
}


/** 转场动画 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    NSString *fromVCString = NSStringFromClass([fromVC class]);
    
    NSString *toVCString = NSStringFromClass([toVC class]);
    
    if ([fromVCString isEqualToString:NSStringFromClass([XBOrderCalendarViewController class])] && [toVCString isEqualToString:NSStringFromClass([XBBookOrderViewController class])]) {
        
        return nil;
        
    } else if ([fromVCString isEqualToString:NSStringFromClass([XBBookOrderViewController class])] && [toVCString isEqualToString:NSStringFromClass([XBOrderCalendarViewController class])]) {
        
        return nil;
    }
    
    return [XBOrderConfirmTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBOrderConfirmTransitionTypePush : XBOrderConfirmTransitionTypePop];
}

- (NSString *)monthOfStringForENUS:(NSInteger)month
{
    NSString *monthString = @"";
    
    switch (month) {
        case 1:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-jan"];
            break;
        case 2:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-feb"];
            break;
        case 3:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-mar"];
            break;
        case 4:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-apr"];
            break;
        case 5:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-may"];
            break;
        case 6:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-jun"];
            break;
        case 7:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-jul"];
            break;
        case 8:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-aug"];
            break;
        case 9:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-sep"];
            break;
        case 10:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-oct"];
            break;
        case 11:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-nov"];
            break;
        case 12:
            
            monthString = [XBLanguageControl localizedStringForKey:@"activity-order-select-dec"];
            break;
            
    }
    
    return monthString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
