//
//  XBPresentOneTransition.m
//  TransitionDemo1
//
//  Created by coder on 16/5/17.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kTabbarHeight 49.f

#import "XBCityPushTransition.h"
#import "XBCityViewController.h"
#import "XBDestinationHotCell.h"
#import "XBDestinationViewController.h"
@interface XBCityPushTransition()
@property (assign, nonatomic) XBCityPushTransitionType  type;
@end
@implementation XBCityPushTransition
+ (instancetype)transitionWithTransitionType:(XBCityPushTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBCityPushTransitionType)type
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
        case XBCityPushTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XBCityPushTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBDestinationViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBCityViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [toVC.coverImageView layoutIfNeeded];
    
    XBDestinationHotCell *cell = [fromVC.hotTableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    
    CGRect coverRect = toVC.coverImageView.frame;
    toVC.coverImageView.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
    
    cell.hidden = YES;
    toVC.coverImageView.image  = cell.coverImageView.image;
    
    [containerView addSubview:toVC.view];
    
    
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:22.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toVC.coverImageView.frame = coverRect;
        
        fromVC.tabBarController.tabBar.xb_y += kTabbarHeight;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
        [UIView animateWithDuration:2.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
        } completion:^(BOOL finished) {
            
            [toVC reloadData];
            
        }];
        
    }];
}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBCityViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBDestinationViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    XBDestinationHotCell *cell = [toVC.hotTableView cellForRowAtIndexPath:toVC.currentIndexPath];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:cell.coverImageView.frame];
    tempView.contentMode  = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    tempView.xb_y  = fromVC.coverImageView.xb_y;
    tempView.xb_x  = fromVC.coverImageView.xb_x;
    tempView.image = cell.coverImageView.image;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];

    [UIView animateWithDuration:.55f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        tempView.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
        
        toVC.tabBarController.tabBar.xb_y -= kTabbarHeight;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
        
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            cell.hidden = NO;
            
            [tempView removeFromSuperview];
            
            [cell.coverImageView.layer addSublayer:cell.shapeLayer];
       
        });
        
    }];
    
}



@end
