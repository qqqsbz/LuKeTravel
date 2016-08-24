//
//  XBCitySearchTransition.m
//  LuKeTravel
//
//  Created by coder on 16/8/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCitySearchTransition.h"
#import "XBCityViewController.h"
#import "XBCitySearchViewController.h"
@interface XBCitySearchTransition()
@property (assign, nonatomic) XBCitySearchTransitionType  type;
@end
@implementation XBCitySearchTransition

+ (instancetype)transitionWithTransitionType:(XBCitySearchTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBCitySearchTransitionType)type
{
    if (self = [super init]) {
        
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XBCitySearchTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case XBCitySearchTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBCityViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBCitySearchViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    toVC.view.alpha = 0;
    
    [toVC.view insertSubview:tempView atIndex:0];
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        toVC.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35];
        
        [transitionContext completeTransition:YES];
    }];
    
}

- (void)dismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBCitySearchViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBCityViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromVC.view];
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * 2.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
}

@end
