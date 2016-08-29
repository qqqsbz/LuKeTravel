//
//  XBOrderDetailTransition.m
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderDetailTransition.h"
#import "XBOrderPrePayNavigationBar.h"
#import "XBOrderNavigationController.h"
#import "XBOrderPrePayViewController.h"
#import "XBOrderDetailViewController.h"
@interface XBOrderDetailTransition()
@property (assign, nonatomic) XBOrderDetailTransitionType  type;
@end
@implementation XBOrderDetailTransition

+ (instancetype)transitionWithTransitionType:(XBOrderDetailTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBOrderDetailTransitionType)type
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
        case XBOrderDetailTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case XBOrderDetailTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBOrderNavigationController *fromNavigationController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBOrderPrePayViewController *fromVC = [fromNavigationController.childViewControllers lastObject];
    
    UINavigationController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    toVC.view.xb_y = containerView.xb_height;

    fromVC.tableView.contentInset = UIEdgeInsetsMake(kTopSpace + 44, 0, 0, 0);
    
    [fromNavigationController.view addSubview:fromVC.orderPrePayNavigationBar];
    
    [containerView addSubview:fromNavigationController.view];
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toVC.view.xb_y = 0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
        [fromVC.orderPrePayNavigationBar removeFromSuperview];
        
        [fromVC.view removeFromSuperview];
    }];
    
    
}

- (void)dismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBOrderNavigationController *toNavigationBar = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    XBOrderPrePayViewController *toVC = [toNavigationBar.childViewControllers lastObject];
    
    UIView *containerView = [transitionContext containerView];

    toVC.view.xb_y = kTopSpace;
    
    toVC.tableView.contentInset = UIEdgeInsetsMake(kTopSpace + 44, 0, 0, 0);
    
    [containerView addSubview:toNavigationBar.view];
    
    [containerView addSubview:fromVC.view];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        fromVC.view.xb_y = containerView.xb_height;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
        toNavigationBar.view.xb_y = kTopSpace;
        
        toNavigationBar.navigationBar.xb_y = 0;
        
        [fromVC.view removeFromSuperview];
    
    }];
    
}

@end
