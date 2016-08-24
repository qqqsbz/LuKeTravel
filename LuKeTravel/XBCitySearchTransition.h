//
//  XBCitySearchTransition.h
//  LuKeTravel
//
//  Created by coder on 16/8/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBCitySearchTransitionType) {
    XBCitySearchTransitionTypePresent = 0,
    XBCitySearchTransitionTypeDismiss
};
@interface XBCitySearchTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBCitySearchTransitionType)type;

- (instancetype)initWithTransitionType:(XBCitySearchTransitionType)type;

@end
