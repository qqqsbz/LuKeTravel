//
//  XBUserInfoViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBUserInfoViewController.h"
#import "XBUser.h"
#import "XBExchange.h"
#import "XBUserInfo.h"
#import "XBPickerView.h"
#import "XBCountryView.h"
#import "NSString+Util.h"
#import "RegexKitLite.h"
#import "XBVerificationCodeView.h"
#import "XBWeChatLoginViewController.h"

@interface XBUserInfoViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,XBPickerViewDelegate,XBPickerViewDatasource,XBVerificationCodeViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
/** 更换头像文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *avatorLabel;
/** 头像 */
@property (strong, nonatomic) IBOutlet UIImageView *avatorImageView;
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
/** 退出登录按钮 */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginOutBarButton;
/** 出行人基本信息 */
@property (strong, nonatomic) IBOutlet UILabel *basicLabel;
/** 保存按钮 */
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
/** 电话号码输入框距离父view右边的距离 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *phoneRightConstraint;
/** 已验证文字说明 */
@property (strong, nonatomic) IBOutlet UILabel *verifiedLabel;
/** 所有的分割线 */
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

/** 国家代码 */
@property (strong, nonatomic) NSString      *code;
/** 用户信息 */
@property (strong, nonatomic) XBUserInfo    *userInfo;
/** 选择框 */
@property (strong, nonatomic) XBPickerView  *pickerView;
/** 当前选中的输入框 */
@property (strong, nonatomic) NSIndexPath   *currentIndexPath;
/** 验证码验证界面 */
@property (strong, nonatomic) XBVerificationCodeView *verificationCodeView;

/** 称谓数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *appellations;
/** 国家数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *countries;
/** 临时数据 用于切换 称谓、国家之间的数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *datas;

@end

@implementation XBUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fill];
    
    [self buildView];
    
    [self loadUserInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadLanguageConfig];
}

- (void)loadUserInfo
{
    [self showLoadinngInView:self.view];

    self.view.userInteractionEnabled = NO;
    
    [[XBHttpClient shareInstance] getUserInfoWithSuccess:^(XBUserInfo *userInfo) {
        
        self.userInfo = userInfo;
        
        self.nameTextField.text = userInfo.firstName;
        
        self.familyTextField.text = userInfo.familyName;
        
        self.emailTextField.text = userInfo.travellerEmail;
        
        self.saveButton.enabled = self.userInfo != nil;
        
        self.appellationTextField.text = userInfo.title.length > 0 ? userInfo.title : [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"];
        
        //如果已经设置了称谓则修改字体颜色
        self.appellationTextField.textColor = [userInfo.title clearBlack].length > 0 ? [UIColor blackColor] : self.appellationTextField.textColor;
        
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        
        //手机号码已验证
        if (userInfo.mobileVerifyStatus) {
            
            NSArray *numbers = [userInfo.mobile componentsSeparatedByString:@"-"];
            
            self.verifiedLabel.hidden = NO;
            
            self.code = [numbers firstObject];
            
            self.codeTextField.text = [NSString stringWithFormat:@"+%@",[numbers firstObject]];
            
            self.phoneTextField.text = [numbers lastObject];
            
            self.phoneRightConstraint.constant = self.view.xb_width - self.verifiedLabel.xb_x;
            
        }
        
        self.view.userInteractionEnabled = YES;
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        if (error.code == kUserUnLoginCode) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-unlogin"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"user-info-logout-confirm"], nil];
            
            [alertView show];
            
            XBWeChatLoginViewController *loginViewController = [[XBWeChatLoginViewController alloc] initWithDismissBlock:^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            
            navigationController.navigationBarHidden = YES;
            
            [self presentViewController:navigationController animated:YES completion:nil];

            
        } else {
            
            [self showFail:[XBLanguageControl localizedStringForKey:@"load-fail"]];
        }
        
    }];
}

- (void)fill
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.avatorImageView.layer.masksToBounds = YES;
    
    self.avatorImageView.layer.cornerRadius  = self.avatorImageView.xb_width / 2.f;
    
    self.verifiedLabel.hidden = YES;
    
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

    
    self.verificationCodeView = [[XBVerificationCodeView alloc] initWithFrame:keyWindow.bounds];
    
    self.verificationCodeView.delegate = self;
    
    [keyWindow addSubview:self.verificationCodeView];
}

- (void)reloadLanguageConfig
{
    UIFont *font = self.appellationTextField.font;
    
    UIColor *textColor = self.appellationTextField.textColor;
    
    self.title = [XBLanguageControl localizedStringForKey:@"user-info-title"];
    
    self.avatorLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-avtaor"];
    
    self.basicLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-basic"];
    
    self.loginOutBarButton.title = [XBLanguageControl localizedStringForKey:@"user-info-loginout"];

    self.appellationLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-appellation"];
    
    self.appellationTextField.text = [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"];
    
    self.nameLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-name"];
    
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-name-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    self.familyLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-family"];
    
    self.familyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-family-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    self.emailLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-email"];
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-email-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    self.codeLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-code"];
    
    self.codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-code-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    self.phoneLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-phone"];
    
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"user-info-phone-placeholder"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    self.verifiedLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-code-verified"];
    
    [self.saveButton setTitle:[XBLanguageControl localizedStringForKey:@"user-info-save"] forState:UIControlStateNormal];
    
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-avtaor"] delegate:self cancelButtonTitle:[XBLanguageControl localizedStringForKey:@"user-info-avator-cancle"] destructiveButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"user-info-avator-album"],[XBLanguageControl localizedStringForKey:@"user-info-avator-camera"], nil];
   
        [actionSheet showInView:self.view];
        
    } else if (indexPath.row == 3) {
        
        self.currentIndexPath = indexPath;
        
        if (!self.pickerView.isShow) {
        
            [self.pickerView toggle];
        }
        
        //防止键盘挡住选择框
        [self.view endEditing:YES];
        
        self.datas = self.appellations;
        
        [self.pickerView reloadData];
        
    } else if (indexPath.row == 4) {
        
        [self.nameTextField becomeFirstResponder];
        
    } else if (indexPath.row == 5) {
        
        [self.familyTextField becomeFirstResponder];
        
    } else if (indexPath.row == 6) {
        
        [self.emailTextField becomeFirstResponder];
        
    } else if (indexPath.row == 7) {
      
        [self.codeTextField becomeFirstResponder];
        
    } else if (indexPath.row == 8) {
        
        [self.phoneTextField becomeFirstResponder];
        
    }
}

- (IBAction)codeAction:(UIButton *)sender {

    self.currentIndexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    
    if (!self.pickerView.isShow) {
        
        [self.pickerView toggle];
    }
    
    //防止键盘挡住选择框
    [self.view endEditing:YES];
    
    self.datas = self.countries;
    
    [self.pickerView reloadData];
}

- (IBAction)saveAction:(UIButton *)sender {
    
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
    
    //如果手机号码尚未认证 或者 手机号码修改了 则进行手机号码认证
    
    phone = [NSString stringWithFormat:@"%@-%@",self.code,phone];
    
    if (!self.userInfo.mobileVerifyStatus || ![self.userInfo.mobile isEqualToString:phone]) {
        
        [self getSmsForPhoneNumber:phone];
        
        return;
    }
    
    [self updateUserInfo:phone];
    
}

- (IBAction)loginOut:(UIBarButtonItem *)sender {

    [XBUserDefaultsUtil clearUserInfo];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-logout-success"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"user-info-logout-confirm"], nil];
    
    [alertView show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.sourceType = buttonIndex == 0 ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.delegate = self;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([type isEqualToString:(NSString*)kUTTypeImage]) {
            
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            
            NSData *imgData = UIImageJPEGRepresentation(image,1);
            
            [self showLoadinngInView:self.view hit:[XBLanguageControl localizedStringForKey:@"user-info-uploading"]];
            
            [[XBHttpClient shareInstance] uploadUserAvatorWith:imgData success:^(NSString *avatorUrl) {
                
                [self hideLoading];
                
                [self showSuccess:[XBLanguageControl localizedStringForKey:@"user-info-upload-success"]];
                
                self.avatorImageView.image = image;
                
                XBUser *user = [XBUserDefaultsUtil userInfo];
                
                user.avatarUrl = avatorUrl;
                
                [XBUserDefaultsUtil updateUserInfo:user];
                
            } failure:^(NSError *error) {
                
                [self hideLoading];
                
                [self showFail:[XBLanguageControl localizedStringForKey:@"user-info-upload-fail"]];
                
            }];
        }
        
    }];
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
    
    if (self.currentIndexPath.row == 3) {
        
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
    
    if (self.currentIndexPath.row == 3) {
        
        self.appellationTextField.text = row == 0 ? [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"] : change.text;
        
        self.appellationTextField.textColor = row == 0 ? [UIColor colorWithHexString:@"#B3B2BA"] : [UIColor blackColor];
        
    } else if (self.currentIndexPath.row == 7) {
        
        self.code = change.text;
        
        self.codeTextField.text = [NSString stringWithFormat:@"+%@",change.text];
        
    }
}


#pragma mark -- XBVerificationCodeViewDelegate
- (void)verificationCodeView:(XBVerificationCodeView *)verificationCodeView didSelecSendWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code
{
    [self showLoadinngInView:self.view];
    //验证验证码是否正确
    [[XBHttpClient shareInstance] postSmsWithPhoneNumber:phoneNumber code:code success:^(BOOL success) {
        
        [self hideLoading];
        
        [self updateUserInfo:phoneNumber];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [self.verificationCodeView showCodeError];
        
    }];
}

- (void)verificationCodeView:(XBVerificationCodeView *)verificationCodeView didSelectResendToPhoneNumber:(NSString *)phoneNumber
{
    [self getSmsForPhoneNumber:phoneNumber];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField) {
        
        NSString *text = [[NSString stringWithFormat:@"%@%@",textField.text,string] clearBlack];
        
        text = [string isEqualToString:@""] ? [text substringToIndex:text.length - 1] : text;
        
        NSString *phone = [[self.userInfo.mobile componentsSeparatedByString:@"-"] lastObject];
        
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

//更新用户资料
- (void)updateUserInfo:(NSString *)phoneNumber
{
    
    self.userInfo.familyName = self.familyTextField.text;
    
    self.userInfo.firstName = self.nameTextField.text;
    
    self.userInfo.title = self.appellationTextField.text;
    
    self.userInfo.travellerEmail = self.emailTextField.text;
    
    self.userInfo.mobile = phoneNumber;
    
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] updateUserInfoWithUserInfo:self.userInfo success:^(BOOL success) {
        
        [self hideLoading];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-success-save"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"user-info-logout-confirm"], nil];
        
        [alertView show];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [self showFail:[XBLanguageControl localizedStringForKey:@"user-info-error-save"]];
        
    }];
}

//获取验证码
- (void)getSmsForPhoneNumber:(NSString *)phoneNumber
{
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] getSmsWithPhoneNumber:phoneNumber success:^(BOOL success) {
        
        [self hideLoading];
        
        self.verificationCodeView.phoneNumber = phoneNumber;
        
        [self.verificationCodeView toggle];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *message = [error.userInfo valueForKey:kErrorMessage] ? [XBLanguageControl localizedStringForKey:@"verification-code-error-get"] : [error.userInfo valueForKey:kErrorMessage];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"commom-alert-confirm"], nil];
        
        [alertView show];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
