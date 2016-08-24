//
//  XBActivityBookOrderTransition.m
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//


#import "XBBookOrderTransition.h"
#import "XBPackage.h"
#import "XBOrderEffectView.h"
#import "XBActivityViewController.h"
#import "XBOrderNavigationController.h"
#import "XBOrderCalendarViewController.h"
@interface XBBookOrderTransition()
@property (assign, nonatomic) XBBookOrderTransitionType  type;
@end
@implementation XBBookOrderTransition

+ (instancetype)transitionWithTransitionType:(XBBookOrderTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBBookOrderTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.f;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XBBookOrderTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case XBBookOrderTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBActivityViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBOrderNavigationController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    XBOrderCalendarViewController *bookOrderVC = [[toVC childViewControllers] firstObject];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    XBOrderEffectView *effectView = [[XBOrderEffectView alloc] initWithFrame:containerView.bounds dismissBlock:^{
        
        [bookOrderVC dismissAction];
        
    }];
    
    effectView.alpha = 0;
    
    effectView.nameLabel.alpha = 0;
    
    effectView.subNameLabel.alpha = 0;
    
    effectView.nameLabel.text = bookOrderVC.package.name;
    
    effectView.subNameLabel.text = bookOrderVC.package.subName;
    
    toVC.view.xb_y = containerView.xb_height;
    
    toVC.view.xb_height -= kTopSpace;
    
    toVC.orderEffectView = effectView;
    
    [containerView addSubview:snapshotView];
    
    [containerView addSubview:toVC.view];
    
    [containerView addSubview:effectView];
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    
        effectView.alpha = 1.f;

    } completion:^(BOOL finished) {
        
        [containerView bringSubviewToFront:toVC.view];
        
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            toVC.view.xb_y += kTopSpace - containerView.xb_height;
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            
            [bookOrderVC reloadArrangements];
            
            [UIView animateWithDuration:1 animations:^{
                
                effectView.nameLabel.alpha = 1;
                
                effectView.subNameLabel.alpha = 1;
                
            }];
            
        }];

    }];

}


- (void)dismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBActivityViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UINavigationController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    XBOrderEffectView *effectView;
    
    UIView *snapshotView = [containerView.subviews firstObject];
    
    for (UIView *view in containerView.subviews) {
    
        if ([view isKindOfClass:[XBOrderEffectView class]]) {
            
            effectView = (XBOrderEffectView *)view;
            
            break;
        }
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        effectView.nameLabel.alpha = 0;
        
        effectView.subNameLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            fromVC.view.xb_y += containerView.xb_height - kTopSpace;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                effectView.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [effectView removeFromSuperview];
                
                [snapshotView removeFromSuperview];
                
                [containerView addSubview:toVC.view];
                
                [transitionContext completeTransition:YES];
                
            }];
            
        }];
        
    }];


}



@end
