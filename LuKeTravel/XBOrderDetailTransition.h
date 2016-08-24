//
//  XBOrderDetailTransition.h
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBOrderDetailTransitionType) {
    XBOrderDetailTransitionTypePresent = 0,
    XBOrderDetailTransitionTypeDismiss
};

@interface XBOrderDetailTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBOrderDetailTransitionType)type;

- (instancetype)initWithTransitionType:(XBOrderDetailTransitionType)type;

@end
