//
//  XBNavigationController.h
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBNavigationController : UINavigationController
/** 返回按钮是否为高亮状态 */
@property (assign, nonatomic, getter=isBackStateNormal) BOOL  backStateNormal;

@end
