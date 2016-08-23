//
//  XBBookConfirmTransition.m
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderConfirmTransition.h"
#import "XBOrderEffectView.h"
#import "XBBookOrderViewController.h"
#import "XBOrderNavigationController.h"
#import "XBOrderTicketViewController.h"
#import "XBOrderTicketNavigationBar.h"
@interface XBOrderConfirmTransition()
@property (assign, nonatomic) XBOrderConfirmTransitionType  type;
@end
@implementation XBOrderConfirmTransition
+ (instancetype)transitionWithTransitionType:(XBOrderConfirmTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBOrderConfirmTransitionType)type
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
        case XBOrderConfirmTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XBOrderConfirmTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBBookOrderViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBOrderTicketViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    XBOrderNavigationController *orderNavigationController = (XBOrderNavigationController *)fromVC.navigationController;
    
    orderNavigationController.orderEffectView.nameLabel.alpha = 0;
    
    orderNavigationController.orderEffectView.subNameLabel.alpha = 0;
    
    UIView *containerView = [transitionContext containerView];
    
    toVC.tableView.contentInset = UIEdgeInsetsMake(containerView.xb_height, 0, 0, 0);
    
    toVC.orderTicketNavigationBar.xb_y = - (kTopSpace + toVC.orderTicketNavigationBar.xb_height);
    
    toVC.orderTicketNavigationBar.dateLabel.alpha = 0;
    
    toVC.orderTicketNavigationBar.countLabel.alpha = 0;
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        toVC.tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
        
        toVC.orderTicketNavigationBar.xb_y = -kTopSpace  * 0.5;
        
    } completion:^(BOOL finished) {
       
        [transitionContext completeTransition:YES];
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
            toVC.orderTicketNavigationBar.xb_height += 30.f;
            
            toVC.orderTicketNavigationBar.dateLabel.alpha = 1;
            
            toVC.orderTicketNavigationBar.countLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBOrderTicketViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBBookOrderViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    XBOrderNavigationController *orderNavigationController = (XBOrderNavigationController *)fromVC.navigationController;
    
    UIView *containerView = [transitionContext containerView];
    
    toVC.navigationController.view.xb_y = containerView.xb_height - toVC.navigationController.view.xb_y;
    
    [containerView addSubview:toVC.view];
    
    [containerView addSubview:fromVC.view];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toVC.navigationController.view.xb_y = kTopSpace;
        
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
        [fromVC.view removeFromSuperview];
        
        [UIView animateWithDuration:1 animations:^{
            
            orderNavigationController.orderEffectView.nameLabel.alpha = 1;
            
            orderNavigationController.orderEffectView.subNameLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}
@end