//
//  XBSubNameView.m
//  LuKeTravel
//
//  Created by coder on 16/7/19.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kItemW 60
#define kItemH 30

#import "XBSubNameView.h"
#import "NSString+Util.h"
#import "XBMoreActivitySubName.h"
#import "XBMoreActivitySubNameItem.h"

@interface XBSubNameView() <UIScrollViewDelegate>
//存放按钮的UIScrollView
@property (strong, nonatomic) UIScrollView  *scrollView;
//分割线
@property (strong, nonatomic) UIView        *separatorView;
//上一个点击的按钮index
@property (assign, nonatomic) CGFloat       previousSelectedIndex;
//当前点击的按钮index
@property (assign, nonatomic) CGFloat       currentSelectedIndex;
//上一次设置的XBMoreActivitySubName 判断是否需要重新创建按钮
@property (strong, nonatomic) XBMoreActivitySubName  *previousSubName;

@end
@implementation XBSubNameView

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
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.separatorView = [[UIView alloc] init];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self addSubview:self.separatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    self.separatorView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.7, CGRectGetWidth(self.frame), 0.7);
}

- (void)setSubName:(XBMoreActivitySubName *)subName
{
    _subName = subName;
    
    if (!subName) return;
    
    if (!_previousSubName || ![[_previousSubName.items lastObject].modelId isEqualToString:[subName.items lastObject].modelId]) {
        
        [self buileMenu];
    
    }
    
    _previousSubName = subName;
}

- (void)buileMenu
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = _subName.items.count;
    
    BOOL existSelected = NO;
    
    XBMoreActivitySubNameItem *subNameItem;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        subNameItem = _subName.items[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i;
        
        btn.layer.masksToBounds = YES;
        
        btn.layer.cornerRadius  = 15.f;
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [btn setTitle:subNameItem.name forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#949494"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([subNameItem.modelId integerValue] == self.subName.selected) {
            
            existSelected = YES;
            
            [btn setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [self.scrollView addSubview:btn];
    }
    
    if (!existSelected) {
        
        UIButton *firstBtn = [self.scrollView.subviews firstObject];
        
        [firstBtn setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
        
        [firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    [self addConstraint];
}

- (void)addConstraint
{
    UIButton *firstBtn = [self.scrollView.subviews firstObject];
    
    UIButton *lastBtn  = [self.scrollView.subviews lastObject];
    
    [firstBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView).offset(kSpace);
        make.width.mas_equalTo([self calculateWidthAtIndex:0]);
        make.height.mas_equalTo(kItemH);
    }];
    
    [lastBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView).offset(-kSpace);
    }];
    
    for (NSInteger i = 1; i < self.scrollView.subviews.count; i ++) {
        
        UIButton *previousBtn = self.scrollView.subviews[i - 1];
        
        UIButton *currentBtn  = self.scrollView.subviews[i];
        
        [currentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(previousBtn);
            make.left.equalTo(previousBtn.right);
            make.width.mas_equalTo([self calculateWidthAtIndex:i]);
            make.height.mas_equalTo(kItemH);
        }];
    }
    
    [lastBtn layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame), CGRectGetHeight(self.scrollView.frame));
    
}

- (CGFloat)calculateWidthAtIndex:(NSInteger)index
{
    XBMoreActivitySubNameItem *firtItem = self.subName.items[index];
    
    UIButton *btn = self.scrollView.subviews[index];
    
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame));
    
    CGSize firstSize = [firtItem.name sizeWithFont:btn.titleLabel.font maxSize:maxSize];
    
    CGFloat width = firstSize.width > 35 ? kItemW + (firstSize.width - 35) : kItemW;
    
    return width;
}

- (void)clickAction:(UIButton *)sender
{
    for (UIButton *btn in self.scrollView.subviews) {
        
        if (btn.tag == sender.tag) {
            
            [btn setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        } else {
            
            [btn setBackgroundColor:[UIColor clearColor]];
            
            [btn setTitleColor:[UIColor colorWithHexString:@"#949494"] forState:UIControlStateNormal];
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(subNameView:didSelectedWithSubNameItem:)]) {
        [self.delegate subNameView:self didSelectedWithSubNameItem:self.subName.items[sender.tag]];
    }
    
    [self autoScrollTopTabBySwipDirctionToPage:sender.tag];
}

- (void)autoScrollTopTabBySwipDirctionToPage:(NSInteger)page {
    
    self.previousSelectedIndex = self.currentSelectedIndex;
    self.currentSelectedIndex = page;
    
    CGFloat tag;
    CGFloat btnX;
    CGFloat subtrace;
    CGFloat spare;
    BOOL    isForwardSwip = self.previousSelectedIndex < page;
    CGFloat tabsOffsetX = self.scrollView.contentOffset.x;
    UIButton *currentSelectedBtn = self.scrollView.subviews[page];
    
    CGFloat tabsFrameWidth = self.scrollView.frame.size.width;
    CGFloat tabsContentWidth = self.scrollView.contentSize.width;
    
    CGFloat frameWidth = self.frame.size.width;
    
    tag = tabsOffsetX + frameWidth / 2 ;
    btnX = currentSelectedBtn.center.x;
    subtrace = isForwardSwip ? btnX - tag : tag - btnX;
    
    if (subtrace >= 0) {
        
        //calculate tab scorll content offset
        spare = isForwardSwip ? tabsContentWidth - (tabsOffsetX + tabsFrameWidth) : tabsOffsetX;
        
        spare = spare < 0 ? 0 : spare;
        
        CGFloat moveX = spare > subtrace ? subtrace : spare;
        
        moveX = isForwardSwip ? tabsOffsetX + moveX : tabsOffsetX - moveX;
        
        //animate change
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.scrollView.contentOffset = CGPointMake(moveX, 0);
                             
                         } completion:nil];
        
    }
    
    [UIView animateWithDuration:.25 animations:^{
        [self layoutIfNeeded];
    }];
    
}


@end
