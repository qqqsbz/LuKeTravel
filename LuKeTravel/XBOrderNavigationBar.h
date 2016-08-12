//
//  XBOrderNavigationBar.h
//  LuKeTravel
//
//  Created by coder on 16/8/10.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBOrderNavigationBar : UIView

/** 返回 */
@property (strong, nonatomic) NSString *backText;

/** 标题 */
@property (strong, nonatomic) NSString *titleText;

- (instancetype)initWithBackBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame backBlock:(dispatch_block_t)block;

@end
