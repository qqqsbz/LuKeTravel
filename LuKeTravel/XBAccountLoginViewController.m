//
//  XBAccountLoginViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/28.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f

#import "XBAccountLoginViewController.h"
#import "RegexKitLite.h"

@interface XBAccountLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIImageView   *coverImageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UIView        *accountView;
@property (strong, nonatomic) UIView        *userNameView;
@property (strong, nonatomic) UIView        *passWordView;
@property (strong, nonatomic) UIView        *separatorView;
@property (strong, nonatomic) UITextField   *userNameTextField;
@property (strong, nonatomic) UITextField   *passWordTextField;
@property (strong, nonatomic) UIButton      *operationButton;
@property (strong, nonatomic) UIButton      *forgetButton;
@end

@implementation XBAccountLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    if (self.userExist) {
      
        [self.passWordTextField becomeFirstResponder];
    
    } else {
        
        [self.userNameTextField becomeFirstResponder];
    
    }
}

- (void)buildView
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.coverImageView = [UIImageView new];
    self.coverImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:self.coverImageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.userExist ? [XBLanguageControl localizedStringForKey:@"login-login-account"] : [XBLanguageControl localizedStringForKey:@"login-login-account"];
    [self.view addSubview:self.titleLabel];

    
    self.accountView = [UIView new];
    self.accountView.layer.masksToBounds = YES;
    self.accountView.layer.cornerRadius  = 4.f;
    self.accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.accountView];
    
    self.userNameView = [UIView new];
    self.userNameView.backgroundColor = [UIColor clearColor];
    [self.accountView addSubview:self.userNameView];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.accountView addSubview:self.separatorView];
    
    self.passWordView = [UIView new];
    self.passWordView.backgroundColor = [UIColor clearColor];
    [self.accountView addSubview:self.passWordView];
    
    self.userNameTextField = [UITextField new];
    self.userNameTextField.text = self.userName;
    self.userNameTextField.delegate = self;
    self.userNameTextField.font = [UIFont systemFontOfSize:14.f];
    self.userNameTextField.borderStyle = UITextBorderStyleNone;
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.textColor = [UIColor colorWithHexString:@"#949494"];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"login-textfield-username-placeholder"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AFAFB0"],NSFontAttributeName:[UIFont systemFontOfSize:13.5f]}];
    [self.userNameView addSubview:self.userNameTextField];
    
    self.passWordTextField = [UITextField new];
    self.passWordTextField.secureTextEntry = YES;
    self.passWordTextField.delegate = self;
    self.passWordTextField.font = [UIFont systemFontOfSize:16.f];
    self.passWordTextField.borderStyle = UITextBorderStyleNone;
    self.passWordTextField.backgroundColor = [UIColor whiteColor];
    self.passWordTextField.textColor = [UIColor blackColor];
    self.passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passWordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"login-textfield-password-placeholder"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AFAFB0"],NSFontAttributeName:[UIFont systemFontOfSize:13.5f]}];
    [self.passWordView addSubview:self.passWordTextField];


    self.operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operationButton.enabled = NO;
    self.operationButton.layer.masksToBounds = YES;
    self.operationButton.layer.cornerRadius  = 4.f;
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.operationButton setTitle:self.userExist ? [XBLanguageControl localizedStringForKey:@"login-login"] : [XBLanguageControl localizedStringForKey:@"login-register"] forState:UIControlStateNormal];
    [self.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.operationButton setBackgroundColor:[UIColor colorWithHexString:@"#9E9E9E"]];
    [self.operationButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.operationButton];
    
    self.forgetButton = [UIButton new];
    self.forgetButton.hidden = !self.userExist;
    self.forgetButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.forgetButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.forgetButton setTitle:[XBLanguageControl localizedStringForKey:@"login-forget"] forState:UIControlStateNormal];
    [self.forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetButton];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountView).offset(kSpace * 0.5);
        make.bottom.equalTo(self.accountView.top).offset(-kSpace);
    }];
    
    [self.accountView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kSpace * 0.9);
        make.right.equalTo(self.view).offset(-kSpace * 0.9);
        make.bottom.equalTo(self.view.centerY).offset(-kSpace * 5.5);
        make.height.mas_equalTo(90.f);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountView);
        make.left.equalTo(self.accountView);
        make.right.equalTo(self.accountView);
        make.height.mas_equalTo(1);
    }];
    
    [self.userNameView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountView);
        make.top.equalTo(self.accountView);
        make.bottom.equalTo(self.separatorView.top);
        make.right.equalTo(self.accountView);
    }];
    
    [self.passWordView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountView);
        make.top.equalTo(self.separatorView.bottom);
        make.bottom.equalTo(self.accountView);
        make.right.equalTo(self.accountView);
    }];
    
    [self.userNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userNameView);
        make.left.equalTo(self.userNameView).offset(kSpace * 1.5);
        make.right.equalTo(self.userNameView).offset(-kSpace * 1.5);
    }];
    
    [self.passWordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passWordView);
        make.left.equalTo(self.passWordView).offset(kSpace * 1.5);
        make.right.equalTo(self.passWordView).offset(-kSpace * 1.5);
    }];
    
    [self.operationButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountView);
        make.right.equalTo(self.accountView);
        make.top.equalTo(self.accountView.bottom).offset(kSpace * 1.5);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.forgetButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.operationButton);
        make.top.equalTo(self.operationButton.bottom).offset(kSpace * 1);
    }];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"]) {
        
        [self.userNameTextField resignFirstResponder];
        
        [self.passWordTextField resignFirstResponder];
        
        [self clickAction:self.operationButton];
        
        return NO;
    }
    
    [self checkTextField:textField string:string];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    
    [self checkTextField:textField string:@""];
    
    return YES;
}

- (void)checkTextField:(UITextField *)textField string:(NSString *)string
{
    NSString *userName = textField == self.userNameTextField ? [NSString stringWithFormat:@"%@%@",textField.text,string] : self.userNameTextField.text;
    
    NSString *passWord = textField == self.passWordTextField ? [NSString stringWithFormat:@"%@%@",textField.text,string] : self.passWordTextField.text;
    
    if ([userName clearBlack].length > 0 && [passWord clearBlack].length > 0) {
        
        [self.operationButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
        
        self.operationButton.enabled = YES;
        
    } else {
        
        [self.operationButton setBackgroundColor:[UIColor colorWithHexString:@"#9E9E9E"]];
        
        self.operationButton.enabled = NO;
    }

}

- (void)clickAction:(UIButton *)sender
{
    if (sender == self.operationButton) {
        
        if (self.userExist) {
            
            [self.userNameTextField resignFirstResponder];
            
            [self.passWordTextField resignFirstResponder];
            
            [self userLogin];
        
        } else {
            
            [self userRegister];
            
        }
        
    } else if (sender == self.forgetButton) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"login-forget-message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"login-alert-confirm"], nil];
        [alertView show];
        
    }
}

- (void)userLogin
{
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] userLoginWithUserName:self.userNameTextField.text passWord:[NSString md5:self.passWordTextField.text] success:^(XBUser *user) {
        
        //保存用户信息
        [XBUserDefaultsUtil updateUserInfo:user];
        
        // 保存货币 语言
        [XBUserDefaultsUtil updateCurrentCurrency:user.currency];
        
        [XBUserDefaultsUtil updateCurrentLanguage:user.language];
        
        [XBLanguageControl setUserlanguage:[XBLanguageControl exchangeUserLanguageToLocalLanguage:user.language]];
        
        //发送登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotificaton object:user];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *message;
        
        if (error.code == kUserNotFoundCode) {
            
            message = [error.userInfo valueForKey:kErrorMessage];
            
        } else {
            
            message = [XBLanguageControl localizedStringForKey:@"login-fail"];
        }
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"login-alert-confirm"], nil];
        
        [alertView show];
        
    }];
}

- (void)userRegister
{
    //判断密码格式是否正确
    NSRange range = [self.passWordTextField.text rangeOfRegex:kPassWordRegex];
    
    if (range.location == NSNotFound) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"login-register-password-error"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"login-alert-confirm"], nil];
        
        [alertView show];
        
        return;
    }
    
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] userRegisterWithUserName:self.userNameTextField.text passWord:[NSString md5:self.passWordTextField.text] success:^(XBUser *user) {
        
        //保存用户信息
        [XBUserDefaultsUtil updateUserInfo:user];
        
        //发送登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotificaton object:user];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [self showFail:[XBLanguageControl localizedStringForKey:@"login-fail"]];
        
    }];
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
