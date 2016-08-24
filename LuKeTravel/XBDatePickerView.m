//
//  XBDatePickerView.m
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDatePickerView.h"
@interface XBDatePickerView()
/** 显示内容 */
@property (strong, nonatomic) UIView *contentView;
/** 分割线 */
@property (strong, nonatomic) UIView *topSeparatorView;
/** 顶部view */
@property (strong, nonatomic) UIView *topView;
/** 完成 */
@property (strong, nonatomic) UIButton *doneButton;
/** 时间选择框 */
@property (strong, nonatomic) UIDatePicker *datePicker;
@end
@implementation XBDatePickerView

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
    self.alpha = 0;
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#D0D5DA"];
    [self addSubview:self.contentView];
    
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.contentView addSubview:self.topView];
    
    self.topSeparatorView = [UIView new];
    self.topSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self.topView addSubview:self.topSeparatorView];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.doneButton setTitleColor:[UIColor colorWithHexString:kDefaultColorHex] forState:UIControlStateNormal];
    [self.doneButton setTitle:[XBLanguageControl localizedStringForKey:@"commom-complete"] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneButton];
    
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.date = [NSDate date];
    [self.contentView addSubview:self.datePicker];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.bottom);
        make.height.mas_equalTo(260.f);
    }];
    
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.topSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.top.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.doneButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.topView).offset(-kSpace);
    }];
    
    [self.datePicker makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.topView.bottom).offset(-kSpace * 0.5);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];

}

- (void)doneAction
{
    if ([self.delegate respondsToSelector:@selector(datePickerView:didDoneWithDate:)]) {
        
        [self.delegate datePickerView:self didDoneWithDate:self.datePicker.date];
    }
    
    if (self.isShow) {
        
        [self toggle];
    }
}


- (void)toggle
{
    [self layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    if (self.contentView.xb_y == self.xb_height) {
        
        self.alpha = 1.;
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.contentView.xb_y = self.xb_height - self.contentView.xb_height;
            
        } completion:^(BOOL finished) {
            
            self.contentView.xb_y = self.xb_height - self.contentView.xb_height;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.alpha = 0.;
            
            self.contentView.xb_y = self.xb_height;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (BOOL)isShow
{
    return self.contentView.xb_y == self.xb_height - self.contentView.xb_height;
}

@end
