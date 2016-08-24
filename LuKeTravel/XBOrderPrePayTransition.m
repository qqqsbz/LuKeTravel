//
//  XBOrderPrePayTransition.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderPrePayTransition.h"
#import "XBOrderTicketNavigationBar.h"
#import "XBOrderPrePayNavigationBar.h"
#import "XBOrderTicketViewController.h"
#import "XBOrderPrePayViewController.h"
#import "XBOrderNavigationController.h"
@interface XBOrderPrePayTransition()
@property (assign, nonatomic) XBOrderPrePayTransitionType  type;
@end
@implementation XBOrderPrePayTransition

+ (instancetype)transitionWithTransitionType:(XBOrderPrePayTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBOrderPrePayTransitionType)type
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
        case XBOrderPrePayTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XBOrderPrePayTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBOrderTicketViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    XBOrderPrePayViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *tempView = [[UIView alloc] initWithFrame:containerView.bounds];
    
    tempView.backgroundColor = toVC.tableView.backgroundColor;

    containerView.backgroundColor = toVC.tableView.backgroundColor;
    
    toVC.tableView.xb_y = containerView.xb_height;
    
    toVC.orderPrePayNavigationBar.xb_y = - (kTopSpace + toVC.orderPrePayNavigationBar.xb_height);
    
    toVC.orderPrePayNavigationBar.dateLabel.alpha = 0;
    
    toVC.orderPrePayNavigationBar.countLabel.alpha = 0;
    
    [containerView addSubview:tempView];
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        toVC.tableView.xb_y = kTopSpace;
        
        toVC.orderPrePayNavigationBar.xb_y = -kTopSpace  * 0.5;
        
    } completion:^(BOOL finished) {
        
        /** 防止动画结束后 "下一步"被隐藏 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            toVC.tableView.contentSize = CGSizeMake(toVC.tableView.contentSize.width, toVC.tableView.contentSize.height + 85);
        });
        
        [transitionContext completeTransition:YES];
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            toVC.orderPrePayNavigationBar.xb_height *= 2.1;
            
            toVC.orderPrePayNavigationBar.dateLabel.hidden = NO;
            
            toVC.orderPrePayNavigationBar.countLabel.hidden = NO;
            
            toVC.orderPrePayNavigationBar.contactNameLabel.hidden = NO;
            
            toVC.orderPrePayNavigationBar.contactPhoneLabel.hidden = NO;
            
            toVC.orderPrePayNavigationBar.contactEmailLabel.hidden = NO;
            
            toVC.orderPrePayNavigationBar.dateLabel.alpha = 1;
            
            toVC.orderPrePayNavigationBar.countLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
        }];
        
    }];
}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBOrderTicketViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    CGFloat tableViewY = toVC.tableView.xb_y;
    
    toVC.orderTicketNavigationBar.xb_height *= 0.5;
    
    toVC.tableView.xb_y = containerView.xb_height;
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toVC.orderTicketNavigationBar.xb_height *= 2;
        
        toVC.tableView.xb_y = tableViewY;
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            toVC.tableView.contentSize = CGSizeMake(toVC.tableView.contentSize.width, toVC.tableView.contentSize.height + kTopSpace);
            
            [transitionContext completeTransition:YES];
            
        });
    }];
    
}
@end
