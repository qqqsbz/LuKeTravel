//
//  XBSearchView.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kTopSpace 30.f
#define kCancleW  90.f
#define kSearchH  64.f
#import "XBSearchView.h"
#import "UIImage+Util.h"
@interface XBSearchView() <UISearchBarDelegate>
@property (strong, nonatomic) UIVisualEffectView    *effectView;
@property (strong, nonatomic) UIVisualEffectView    *searchEffectView;
@property (strong, nonatomic) UIView                *searchView;
@property (strong, nonatomic) UISearchBar           *searchBar;
@property (strong, nonatomic) UIButton              *cancleButton;
@property (strong, nonatomic) UIView                *separatorView;
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
    
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.layer.cornerRadius  = 5.f;
    self.searchBar.placeholder = [XBLanguageControl localizedStringForKey:@"search-placeholder"];
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType     = UITextAutocorrectionTypeNo;
    self.searchBar.tintColor = [UIColor colorWithHexString:kDefaultColorHex];
    self.searchBar.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [[[self.searchBar.subviews firstObject] subviews] lastObject].backgroundColor = [UIColor clearColor];
    [self addSubview:self.searchBar];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancleButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [self.cancleButton setTitle:[XBLanguageControl localizedStringForKey:@"search-cancel"] forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:kDefaultColorHex] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancleButton];
    
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1"];
    [self addSubview:self.separatorView];
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
        make.top.equalTo(self.searchView).offset(kTopSpace * 0.9);
        make.right.equalTo(self.searchView).offset(-kSpace * 0.7);
        make.bottom.equalTo(self.searchView).offset(-kSpace * 0.8);
    }];
    
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView).offset(kSpace);
        make.right.equalTo(self.cancleButton.left).offset(-kSpace * 0.7);
        make.top.equalTo(self.cancleButton);
        make.bottom.equalTo(self.cancleButton);
    }];
    
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
    
    
}

#pragma mark -- UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.delegate respondsToSelector:@selector(searchViewTextDidChange:)]) {
        [self.delegate searchViewTextDidChange:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(searchViewDidSelectedCancle)]) {
        [self.delegate searchViewSearchButtonClicked:searchBar.text];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(searchViewDidBeginEditing)]) {
        [self.delegate searchViewDidBeginEditing];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(searchViewDidEndEditing)]) {
        [self.delegate searchViewDidEndEditing];
    }
}

- (void)cancleAction
{
    if ([self.delegate respondsToSelector:@selector(searchViewDidSelectedCancle)]) {
        [self.delegate searchViewDidSelectedCancle];
    }
}

- (void)setBecomFirstreSpondent:(BOOL)becomFirstreSpondent
{
    _becomFirstreSpondent = becomFirstreSpondent;
    
    if (becomFirstreSpondent) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
}

- (void)setSearchText:(NSString *)searchText
{
    self.searchBar.text = searchText;
}

- (NSString *)searchText
{
    return self.searchBar.text;
}

@end
