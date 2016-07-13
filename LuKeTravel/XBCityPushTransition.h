//
//  XBPresentOneTransition.h
//  TransitionDemo1
//
//  Created by coder on 16/5/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XBCityPushTransitionType) {
    XBCityPushTransitionTypePush = 0,
    XBCityPushTransitionTypePop
};
@interface XBCityPushTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBCityPushTransitionType)type;

- (instancetype)initWithTransitionType:(XBCityPushTransitionType)type;

@end
