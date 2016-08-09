//
//  XBLoginViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#import "XBWeChatLoginViewController.h"
#import "RegexKitLite.h"
#import "NSString+Util.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"
#import "XBAccountLoginViewController.h"

@interface XBWeChatLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIImageView   *coverImageView;
@property (strong, nonatomic) UIView        *weChatView;
@property (strong, nonatomic) UIImageView   *weChatImageView;
@property (strong, nonatomic) UILabel       *weChatTitleLabel;
@property (strong, nonatomic) UILabel       *loginTitleLabel;
@property (strong, nonatomic) UIView        *textView;
@property (strong, nonatomic) UITextField   *textField;
@property (strong, nonatomic) UIButton      *loginButton;
@property (strong, nonatomic) UIButton      *loginTipButton;
@property (copy  , nonatomic) dispatch_block_t  dismissBlock;
@end

@implementation XBWeChatLoginViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        [self buildView];
    }
    return self;
}

- (instancetype)initWithDismissBlock:(dispatch_block_t)dismissBlock
{
    if (self = [super init]) {
        
        _dismissBlock = dismissBlock;
        
        [self buildView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self buildView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationRightButton.hidden = YES;
    
    self.navigationView.backgroundColor = [UIColor clearColor];
    
    self.navigationSeparatorView.hidden = YES;
    
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    
}

- (void)buildView
{
    self.coverImageView = [UIImageView new];
    self.coverImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:self.coverImageView];
    
    self.weChatView = [UIView new];
    self.weChatView.layer.masksToBounds = YES;
    self.weChatView.layer.cornerRadius  = 4.f;
    self.weChatView.backgroundColor = [UIColor colorWithHexString:@"#159143"];
    [self.weChatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatLoginAction)]];
    [self.view addSubview:self.weChatView];
    
    self.weChatImageView = [UIImageView new];
    self.weChatImageView.image = [UIImage imageNamed:@"wechat_icon"];
    [self.weChatView addSubview:self.weChatImageView];
    
    self.weChatTitleLabel = [UILabel new];
    self.weChatTitleLabel.textColor = [UIColor whiteColor];
    self.weChatTitleLabel.font = [UIFont systemFontOfSize:16.f];
    self.weChatTitleLabel.text = [XBLanguageControl localizedStringForKey:@"login-wechat"];
    [self.weChatView addSubview:self.weChatTitleLabel];

    
    self.loginTitleLabel = [UILabel new];
    self.loginTitleLabel.font = [UIFont systemFontOfSize:16.f];
    self.loginTitleLabel.textColor = [UIColor whiteColor];
    self.loginTitleLabel.text = [XBLanguageControl localizedStringForKey:@"login-title"];
    [self.view addSubview:self.loginTitleLabel];
    
    self.textView = [UIView new];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius  = 4.f;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.text = @"wuxubin1992@qq.com";
    self.textField.font = [UIFont systemFontOfSize:14.f];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.textColor = [UIColor colorWithHexString:@"#949494"];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"login-textfield-username-placeholder"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AFAFB0"],NSFontAttributeName:[UIFont systemFontOfSize:13.5f]}];
    [self.textView addSubview:self.textField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.enabled = NO;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius  = 4.f;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.loginButton setTitle:[XBLanguageControl localizedStringForKey:@"login-login-register"] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithHexString:@"#9E9E9E"]];
    [self.loginButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.loginTipButton = [UIButton new];
    [self.loginTipButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.loginTipButton setTitle:[XBLanguageControl localizedStringForKey:@"login-tip"] forState:UIControlStateNormal];
    [self.loginTipButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.65] forState:UIControlStateNormal];
    [self.loginTipButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginTipButton];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.weChatView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView);
        make.right.equalTo(self.textView);
        make.bottom.equalTo(self.loginTitleLabel.top).offset(-kSpace * 4.f);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.weChatTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weChatView);
        make.centerX.equalTo(self.weChatView).offset(kSpace * 2);
    }];
    
    [self.weChatImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weChatView);
        make.right.equalTo(self.weChatTitleLabel.left).offset(-kSpace * 0.5);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.centerY).offset(kSpace * 2);
        make.left.equalTo(self.view).offset(kSpace * 1.5);
        make.right.equalTo(self.view).offset(-kSpace * 1.5);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textView);
        make.left.equalTo(self.textView).offset(kSpace * 1.5);
        make.right.equalTo(self.textView).offset(-kSpace);
    }];
    
    [self.loginTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView);
        make.bottom.equalTo(self.textView.top).offset(-kSpace * 1.);
    }];
    
    [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView);
        make.right.equalTo(self.textView);
        make.top.equalTo(self.textView.bottom).offset(kSpace * 1.7f);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.loginTipButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSpace * 4.5);
    }];
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if ([string isEqualToString:@"\n"]) {
        
        [self.textField resignFirstResponder];
        
        [self clickAction:self.loginButton];
        
        return NO;
    }
    
    NSString *text = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if ([text clearBlack].length > 0) {
        
        [self.loginButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
        
        self.loginButton.enabled = YES;
    
    } else {
        
        [self.loginButton setBackgroundColor:[UIColor colorWithHexString:@"#9E9E9E"]];
        
        self.loginButton.enabled = NO;
    }
    
    return YES;
}

- (void)leftButtonAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.dismissBlock) {
            
            self.dismissBlock();
        }
        
    }];
}

- (void)clickAction:(UIButton *)sender
{
    if (sender == self.loginButton) {
        
        NSRange range = [self.textField.text rangeOfRegex:kEmailRegex];
        
        if (range.location == NSNotFound) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"login-alert-message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"login-alert-confirm"], nil];
            [alertView show];
         
            return;
        }
        
        [self showLoadinngInView:self.view];
        
        [[XBHttpClient shareInstance] getRestLoginWithUserName:self.textField.text success:^(BOOL isexist) {
            
            [self hideLoading];
            
            XBAccountLoginViewController *accountLoginVC = [[XBAccountLoginViewController alloc] init];
            
            accountLoginVC.userExist = isexist;
            
            accountLoginVC.userName = self.textField.text;
            
            [self.navigationController pushViewController:accountLoginVC animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    } else if (sender == self.loginTipButton) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:kConditionsUrl,[XBUserDefaultsUtil currentLanguage]]]];
        
    }
}

- (void)weChatLoginAction
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
