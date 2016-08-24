//
//  XBBookConfirmTransition.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBOrderTicketTransitionType) {
    XBOrderTicketTransitionTypePush = 0,
    XBOrderTicketTransitionTypePop
};


@interface XBOrderTicketTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBOrderTicketTransitionType)type;

- (instancetype)initWithTransitionType:(XBOrderTicketTransitionType)type;

@end
