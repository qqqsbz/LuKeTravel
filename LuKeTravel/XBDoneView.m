//
//  XBDoneView.m
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDoneView.h"
@interface XBDoneView()
@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *textLabel;
@end

@implementation XBDoneView

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
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"scan_done"];
    [self addSubview:self.imageView];
    
    self.textLabel = [UILabel new];
    self.textLabel.font = [UIFont systemFontOfSize:16.f];
    self.textLabel.text = NSLocalizedString(@"feedback-done", @"feedback-done");
    self.textLabel.textColor = [UIColor colorWithHexString:@"#575757"];
    [self addSubview:self.textLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.centerY);
    }];
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.bottom).offset(kSpace * 2.2);
    }];
}

+ (void)showWithCompleteBlock:(dispatch_block_t)block
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *maskView = [[UIView alloc] initWithFrame:window.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55f];
    [window addSubview:maskView];
    
    XBDoneView *doneView = [[XBDoneView alloc] initWithFrame:CGRectMake(0, -125, 210, 125)];
    doneView.backgroundColor = [UIColor whiteColor];
    doneView.layer.masksToBounds = YES;
    doneView.layer.cornerRadius  = 8.f;
    doneView.xb_centerX = window.xb_centerX;
    [window addSubview:doneView];
    
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:20 options:UIViewAnimationOptionCurveLinear animations:^{
        
        doneView.xb_centerY = window.xb_centerY;
        
    } completion:^(BOOL finished) {
        
        if (block) {
            block();
        }
        
        [doneView removeFromSuperview];
        
        [maskView removeFromSuperview];
        
    }];
    
}

@end
