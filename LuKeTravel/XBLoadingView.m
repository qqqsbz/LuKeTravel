//
//  XBLoadingView.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kLoadingImageWH 70.f
#define kInitImageXY    (CGRectGetWidth(loadingView.frame) - kLoadingImageWH) / 2.f
#define kLoadingImageXY (CGRectGetWidth(self.frame) - kLoadingImageWH) / 2.f
#import "XBLoadingView.h"
#import <objc/runtime.h>
@interface XBLoadingView()
@property (strong, nonatomic) UIImageView  *loadingImageView;
@property (assign, nonatomic) NSInteger    duration;
@property (assign, nonatomic) NSInteger    currentIndex;
@property (strong, nonatomic) NSArray      *images;
@end

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;
@implementation XBLoadingView

+ (UIView *)HUD
{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

+ (void)setHUD:(UIView *)HUD
{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)showInView:(UIView *)view
{
    UIView *maskView = [[UIView alloc] initWithFrame:view.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55f];
    [view addSubview:maskView];
    [XBLoadingView setHUD:maskView];
    
    XBLoadingView *loadingView = [[XBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingView.center = view.center;
    loadingView.layer.cornerRadius  = 7.f;
    loadingView.layer.masksToBounds = YES;
    loadingView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:loadingView];
    
    loadingView.loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-(CGRectGetWidth(loadingView.frame) + kLoadingImageWH), kInitImageXY, kLoadingImageWH, kLoadingImageWH)];
    [loadingView addSubview:loadingView.loadingImageView];
    
    
    loadingView.duration = 1.f;
    
    loadingView.currentIndex = 0;
    
    loadingView.images = @[[UIImage imageNamed:@"loadImage1"],
                           [UIImage imageNamed:@"loadImage2"],
                           [UIImage imageNamed:@"loadImage3"],
                           [UIImage imageNamed:@"loadImage4"],
                           [UIImage imageNamed:@"loadImage5"],
                           [UIImage imageNamed:@"loadImage6"],
                           [UIImage imageNamed:@"loadImage7"],
                           [UIImage imageNamed:@"loadImage8"]
                          ];
    
    [loadingView showAnimationFromRight];
    
}

- (void)showAnimationFromTop
{
    self.loadingImageView.image = self.images[self.currentIndex];
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:250.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loadingImageView.frame = CGRectMake(kLoadingImageXY, kLoadingImageXY, kLoadingImageWH, kLoadingImageWH);
    } completion:^(BOOL finished) {
        self.loadingImageView.frame = CGRectMake(-(CGRectGetWidth(self.frame) + kLoadingImageWH), kLoadingImageXY, kLoadingImageWH, kLoadingImageWH);
        [self calculateCurrentIndex];
        [self showAnimationFromRight];
    }];
}

- (void)showAnimationFromRight
{
    self.loadingImageView.image = self.images[self.currentIndex];
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:250.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loadingImageView.frame = CGRectMake(kLoadingImageXY, kLoadingImageXY, kLoadingImageWH, kLoadingImageWH);
    } completion:^(BOOL finished) {
        self.loadingImageView.frame = CGRectMake(kLoadingImageXY, CGRectGetHeight(self.frame) + kLoadingImageWH, kLoadingImageWH, kLoadingImageWH);
        [self calculateCurrentIndex];
        [self showAnimationFromTop];
    }];
}

- (void)calculateCurrentIndex
{
    if (self.currentIndex != self.images.count - 1) {
        self.currentIndex ++;
    } else {
        self.currentIndex = 0;
    }
}

+ (void)hide
{
    [[XBLoadingView HUD] removeFromSuperview];
}

@end
