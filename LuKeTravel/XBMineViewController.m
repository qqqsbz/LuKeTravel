//
//  XBMineViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/28.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBMineViewController.h"
#import "XBUserInfoViewController.h"
#import "XBWeChatLoginViewController.h"
@interface XBMineViewController ()
@property (strong, nonatomic) IBOutlet UILabel *referDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) IBOutlet UILabel *voucherLabel;
@property (strong, nonatomic) IBOutlet UILabel *favLabel;
@property (strong, nonatomic) IBOutlet UILabel *referLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *creditsLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponsLabel;
@property (strong, nonatomic) IBOutlet UIView *scSeparatorView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *voucherConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *creditConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exchangeConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutConstraint;

@end

@implementation XBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentToLoginViewController) name:kUserUnLoginNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
 
    [self reloadLanguageConfig];
}

- (void)reloadLanguageConfig
{
    XBUser *user = [XBUserDefaultsUtil userInfo];
    
    self.title = [XBLanguageControl localizedStringForKey:@"mine-title"];
    
    self.loginLabel.text = [XBLanguageControl localizedStringForKey:@"mine-login"];
    
    self.messageLabel.text = [XBLanguageControl localizedStringForKey:@"mine-message"];
    
    self.voucherLabel.text = [XBLanguageControl localizedStringForKey:@"mine-voucher"];
    
    self.favLabel.text = [XBLanguageControl localizedStringForKey:@"mine-fav"];
    
    self.referLabel.text = [XBLanguageControl localizedStringForKey:@"mine-refer"];
    
    self.referDetailLabel.text = [XBLanguageControl localizedStringForKey:@"mine-refer-detail"];
    
    self.creditLabel.text = [XBLanguageControl localizedStringForKey:@"mine-credit"];
    
    self.exchangeLabel.text = [XBLanguageControl localizedStringForKey:@"mine-exchange"];
    
    self.helpLabel.text = [XBLanguageControl localizedStringForKey:@"mine-help"];
    
    self.aboutLabel.text = [XBLanguageControl localizedStringForKey:@"mine-about"];
    
    self.avatorImageView.hidden = user == nil;
    
    self.iconImageView.hidden = user != nil;
    
    self.messageLabel.hidden = user != nil;
    
    self.creditsLabel.hidden = user == nil;
    
    self.scSeparatorView.hidden = user == nil;
    
    self.couponsLabel.hidden = user == nil;
    
    if (user) {
        
        self.loginLabel.text = user.userName;
        
        self.creditsLabel.text = [[XBLanguageControl localizedStringForKey:@"mine-credits"] stringByAppendingString:[NSString stringWithFormat:@" %@",[NSIntegerFormatter formatToNSString:user.credits]]];
        
        self.couponsLabel.text = [[XBLanguageControl localizedStringForKey:@"mine-coupons"] stringByAppendingString:[NSString stringWithFormat:@" %@",[NSIntegerFormatter formatToNSString:user.validCoupons]]];
        
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        
    }
    
}

- (void)buildView
{
    self.voucherConstraint.constant = 0.5f;
    
    self.creditConstraint.constant = 0.5;
    
    self.exchangeConstraint.constant = 0.5f;
    
    self.aboutConstraint.constant = 0.5f;
    
    self.headerBottomConstraint.constant = 0.5f;
    
    self.headerTopConstraint.constant = 0.5f;
    
    self.avatorImageView.layer.masksToBounds = YES;
    
    self.avatorImageView.layer.cornerRadius  = self.avatorImageView.xb_height / 2.f;
    
    self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;

    self.avatorImageView.layer.borderWidth = 1.5f;
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self setNeedsStatusBarAppearanceUpdate];

}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 3 ? 0.1 : [super tableView:tableView heightForHeaderInSection:section];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if ((indexPath.section == 0 || indexPath.section == 1 ) && ![XBUserDefaultsUtil userInfo]) {
            
            [self presentToLoginViewController];
            
            return NO;
            
        }
        
    }
    return YES;
}

- (void)presentToLoginViewController
{
    XBWeChatLoginViewController *loginViewController = [[XBWeChatLoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
