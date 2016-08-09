//
//  XBInviteViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBInviteViewController.h"
#import "XBInvite.h"
#import "XBShareView.h"
#import "XBShareActivity.h"
@interface XBInviteViewController ()
/** 内容view  */
@property (strong, nonatomic) UIView        *contentView;
/** 奖励金额 */
@property (strong, nonatomic) UILabel       *rewardLabel;
/** 奖励图标 */
@property (strong, nonatomic) UIImageView   *rewardImageView;
/** 标题 */
@property (strong, nonatomic) UILabel       *titleLabel;
/** 说明 */
@property (strong, nonatomic) UILabel       *textLabel;
/** 邀请码 */
@property (strong, nonatomic) UIButton      *codeButton;
/** 邀请码说明 */
@property (strong, nonatomic) UILabel       *codeTextLabel;
/** 邀请按钮 */
@property (strong, nonatomic) UIButton      *sendButton;
/** 分享页面 */
@property (strong, nonatomic) XBShareView   *shareView;
/** 邀请数据 */
@property (strong, nonatomic) XBInvite      *invite;
@end

@implementation XBInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kLoginSuccessNotificaton object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.shareView removeFromSuperview];
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] getReferLinkWithSuccess:^(XBInvite *invite) {
        
        self.invite = invite;
        
        self.contentView.hidden = NO;
        
        self.rewardLabel.text = invite.bonus;
        
        self.textLabel.text = invite.detail;
        
        self.codeButton.enabled = YES;
        
        self.sendButton.enabled = YES;
        
        [self.codeButton setTitle:invite.code forState:UIControlStateNormal];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        if (error.code == kUserUnLoginCode) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserUnLoginNotification object:nil];
        
        } else {
        
            [self showFail:[XBLanguageControl localizedStringForKey:@"loading-fail"] inView:self.view];
        }
        
    }];
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.title = [XBLanguageControl localizedStringForKey:@"invite-title"];
    
    self.contentView = [UIView new];
    self.contentView.hidden = YES;
    self.contentView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.contentView];
    
    self.rewardLabel = [UILabel new];
    self.rewardLabel.textColor = [UIColor blackColor];
    self.rewardLabel.font = [UIFont systemFontOfSize:30.f];
    [self.contentView addSubview:self.rewardLabel];

    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"invite-content-title"];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:self.titleLabel];
    
    self.textLabel = [UILabel new];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
    self.textLabel.text = [XBLanguageControl localizedStringForKey:@"invite-content-text"];
    self.textLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.textLabel];
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.enabled = NO;
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.codeButton setTitle:@"JF9J2" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.codeButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
    [self.contentView addSubview:self.codeButton];
    
    self.codeTextLabel = [UILabel new];
    self.codeTextLabel.text = [XBLanguageControl localizedStringForKey:@"invite-code-text"];
    self.codeTextLabel.textColor = [UIColor colorWithHexString:@"#A3A3A3"];
    self.codeTextLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.codeTextLabel];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.enabled = NO;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius  = 6.f;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.sendButton setTitle:[XBLanguageControl localizedStringForKey:@"invite-send"] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"#FF3116"]];
    [self.sendButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.rewardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel.top).offset(- kSpace * 5.5);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.textLabel.top).offset(-kSpace * 1.5);
    }];
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace * 2);
        make.right.equalTo(self.contentView).offset(-kSpace * 2);
        make.bottom.equalTo(self.codeTextLabel.top).offset(-kSpace * 5);
    }];
    
    [self.codeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.centerY).offset(kSpace * 2);
    }];
    
    [self.codeTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.codeButton.bottom);
    }];
    
    [self.sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextLabel.bottom).offset(kSpace * 3);
        make.left.equalTo(self.contentView).offset(kSpace * 5);
        make.right.equalTo(self.contentView).offset(-kSpace * 5);
        make.height.mas_equalTo(45.f);
    }];
}

#pragma mark -- show menu
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    [self.codeButton layoutIfNeeded];
    
    [self.codeButton becomeFirstResponder];
    
    UIMenuItem *copyCode = [[UIMenuItem alloc] initWithTitle:[XBLanguageControl localizedStringForKey:@"invite-code-copy"] action:@selector(copyAction:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:copyCode, nil]];
    
    [menu setTargetRect:self.codeButton.frame inView:self.view];
    
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

// 用于UIMenuController显示，缺一不可
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyAction:)){
        
        return YES;
    }
    
    return NO;
}

- (void)copyAction:(id *)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.URL = [NSURL URLWithString:self.invite.referUrl];
}

- (void)shareAction
{
    [self.shareView toggle];
}


- (XBShareView *)shareView
{
    if (!_shareView) {
        
        XBShareActivity *shareActivity = [XBShareActivity shareActivityWithTitle:self.invite.title subTitle:self.invite.body image:self.invite.referImage url:self.invite.referUrl];
        
        _shareView = [[XBShareView alloc] initWithFrame:self.navigationController.view.bounds shareActivity:shareActivity targetViewController:self dismissBlock:nil];
        
        _shareView.title = [XBLanguageControl localizedStringForKey:@"invite-share-title"];
        
        [self.navigationController.view addSubview:_shareView];
    }
    return _shareView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
