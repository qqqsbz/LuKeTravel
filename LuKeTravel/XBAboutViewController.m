//
//  XBAboutViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBAboutViewController.h"

@interface XBAboutViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
@property (strong, nonatomic) IBOutlet UILabel *titileLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *contanctLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *churchyardLabel;
@property (strong, nonatomic) IBOutlet UILabel *overseasLabel;
@property (strong, nonatomic) IBOutlet UILabel *appStoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (strong, nonatomic) IBOutlet UILabel *clauseLabel;
@property (strong, nonatomic) IBOutlet UILabel *accessLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

@end

@implementation XBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillConfig];

}

- (void)fillConfig
{
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        constraint.constant = 0.5f;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadLanguageConfig];
}

- (void)reloadLanguageConfig
{
    self.title = [XBLanguageControl localizedStringForKey:@"about-title"];

    self.titileLabel.text = [XBLanguageControl localizedStringForKey:@"about-text"];
    
    self.versionLabel.text = [NSString stringWithFormat:@"%@ %@",[XBLanguageControl localizedStringForKey:@"about-version"],[XBApplication shortVersion]];
    
    self.contanctLabel.text = [XBLanguageControl localizedStringForKey:@"about-contact"];
    
    self.emailLabel.text = [XBLanguageControl localizedStringForKey:@"about-email"];
    
    self.churchyardLabel.text = [XBLanguageControl localizedStringForKey:@"about-phone-churchyard"];
    
    self.overseasLabel.text = [XBLanguageControl localizedStringForKey:@"about-phone-overseas"];
    
    self.appStoreLabel.text = [XBLanguageControl localizedStringForKey:@"about-appstore"];
    
    self.feedbackLabel.text = [XBLanguageControl localizedStringForKey:@"about-feedback"];
    
    self.clauseLabel.text = [XBLanguageControl localizedStringForKey:@"about-clause"];
    
    self.accessLabel.text = [XBLanguageControl localizedStringForKey:@"about-website"];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",kEmail]]];
            
        } else if (indexPath.row == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",kPhoneChurchyard]]];
            
        } else if (indexPath.row == 2) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",kPhoneOverseas]]];
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://%@",kAppStore]]];
            
        } else if (indexPath.row == 3) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:kConditionsUrl,[XBUserDefaultsUtil currentLanguage]]]];
            
        } else if (indexPath.row == 4) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[kWebSite stringByAppendingString:[NSString stringWithFormat:@"/%@",[XBUserDefaultsUtil currentLanguage]]]]];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
