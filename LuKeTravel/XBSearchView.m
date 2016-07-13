//
//  XBSearchView.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace    10.f
#define kTopSpace 30.f
#define kCancleW  90.f
#define kSearchH  64.f
#import "XBSearchView.h"
@interface XBSearchView()
@property (strong, nonatomic) UIVisualEffectView    *effectView;
@property (strong, nonatomic) UIVisualEffectView    *searchEffectView;
@property (strong, nonatomic) UIView                *searchView;
@property (strong, nonatomic) UITextField           *textField;
@property (strong, nonatomic) UIButton              *cancleButton;
@end
@implementation XBSearchView
- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:self.effectView];
    
    self.searchView = [UIView new];
    self.searchView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:self.searchView];
    
    self.searchEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self.searchView addSubview:self.searchEffectView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace, 0, kSpace, 18)];
    leftImageView.image = [UIImage imageNamed:@"search"];
    
    self.textField = [UITextField new];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.textColor   = [UIColor colorWithHexString:@"#161616"];
    self.textField.tintColor   = [UIColor colorWithHexString:kDefaultColorHex];
    self.textField.font        = [UIFont systemFontOfSize:13.5f];
    self.textField.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius  = 5.f;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"search-placeholder", @"search-placeholder") attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#96969A"]}];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView     = leftImageView;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textField];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.f]];
    [self.cancleButton setTitle:NSLocalizedString(@"search-cancle", @"search-cancle") forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:kDefaultColorHex] forState:UIControlStateNormal];
    [self addSubview:self.cancleButton];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.searchView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(kSearchH);
    }];
    
    [self.searchEffectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.cancleButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView).offset(kTopSpace);
        make.right.equalTo(self.searchView).offset(-kSpace);
        make.bottom.equalTo(self.searchView).offset(-kSpace * 0.5);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView).offset(kSpace);
        make.right.equalTo(self.cancleButton.left).offset(-kSpace);
        make.top.equalTo(self.cancleButton);
        make.bottom.equalTo(self.cancleButton);
    }];
    
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    
    
    
}

@end
