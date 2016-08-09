//
//  XBFeedBackViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBFeedBackViewController.h"
#import "RegexKitLite.h"
#import "XBDoneView.h"
@interface XBFeedBackViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *contentPlaceHolderLabel;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation XBFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadLanguageConfig];
}

- (void)fillView
{
   CGColorRef borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    
    self.nameView.layer.masksToBounds = YES;
    
    self.nameView.layer.cornerRadius  = 8.f;
    
    self.nameView.layer.borderWidth = 1.f;
    
    self.nameView.layer.borderColor = borderColor;
    
    self.emailView.layer.masksToBounds = YES;
    
    self.emailView.layer.cornerRadius  = 8.f;
    
    self.emailView.layer.borderWidth = 1.f;
    
    self.emailView.layer.borderColor = borderColor;
    
    self.contentView.layer.masksToBounds = YES;
    
    self.contentView.layer.cornerRadius  = 8.f;
    
    self.contentView.layer.borderWidth = 1.f;
    
    self.contentView.layer.borderColor = borderColor;
    
    self.submitButton.layer.masksToBounds = YES;
    
    self.submitButton.layer.cornerRadius  = 7.f;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
    
}

- (void)reloadLanguageConfig
{
    
    self.navigationItem.title = [XBLanguageControl localizedStringForKey:@"feedback-title"];
    
    self.nameLabel.text = [XBLanguageControl localizedStringForKey:@"feedback-name"];
    
    self.nameTextField.placeholder = [XBLanguageControl localizedStringForKey:@"feedback-name-placeholder"];
    
    self.emailLabel.text = [XBLanguageControl localizedStringForKey:@"feedback-email"];
    
    self.emailTextField.placeholder = [XBLanguageControl localizedStringForKey:@"feedback-email-placeholder"];
    
    self.contentLabel.text = [XBLanguageControl localizedStringForKey:@"feedback-content"];
    
    self.contentPlaceHolderLabel.text = [XBLanguageControl localizedStringForKey:@"feedback-content-placeholder"];
    
    [self.submitButton setTitle:[XBLanguageControl localizedStringForKey:@"feedback-submit"] forState:UIControlStateNormal];
    

}

#pragma mark -- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.contentPlaceHolderLabel.hidden = [[NSString stringWithFormat:@"%@%@",textView.text,text] clearBlack] > 0;
    return YES;
}

- (IBAction)submitAction:(UIButton *)sender {
    
    NSString *name = self.nameTextField.text;
    
    NSString *email = self.emailTextField.text;
    
    NSString *content = self.contentTextView.text;
    
    if ([name clearBlack].length <= 0 || [email clearBlack].length <= 0 || [content clearBlack].length <= 0) {
        
        [self showToast:[XBLanguageControl localizedStringForKey:@"feedback-error-all"]];
        
        return;
        
    }
    
    if ([email rangeOfRegex:kEmailRegex].location == NSNotFound) {
        
        [self showToast:[XBLanguageControl localizedStringForKey:@"feedback-error-email"]];
        
        return;
    }
    
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] postFeedBackWithName:name contact:email content:content success:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            [XBDoneView showWithCompleteBlock:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            
            }];
        }
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [self showToast:[XBLanguageControl localizedStringForKey:@"feedback-fail"]];
        
    }];
    
}

- (void)dismissAction
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
