//
//  XBBookConfirmTransition.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBBookOrderTransitionType) {
    XBBookOrderTransitionTypePresent = 0,
    XBBookOrderTransitionTypeDismiss
};


@interface XBBookConfirmTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBBookOrderTransitionType)type;

- (instancetype)initWithTransitionType:(XBBookOrderTransitionType)type;

@end
