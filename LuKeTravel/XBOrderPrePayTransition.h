//
//  XBOrderPrePayTransition.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBOrderPrePayTransitionType) {
    XBOrderPrePayTransitionTypePush = 0,
    XBOrderPrePayTransitionTypePop
};

@interface XBOrderPrePayTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBOrderPrePayTransitionType)type;

- (instancetype)initWithTransitionType:(XBOrderPrePayTransitionType)type;


@end
