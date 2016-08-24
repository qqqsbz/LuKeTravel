//
//  XBGuideView.h
//  LuKeTravel
//
//  Created by coder on 16/8/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBGuideView : UIView

- (instancetype)initWitImages:(NSArray<UIImage *> *)images titles:(NSArray<NSString *> *)titles contents:(NSArray<NSString *> *)contents complete:(dispatch_block_t)complete;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images titles:(NSArray<NSString *> *)titles contents:(NSArray<NSString *> *)contents complete:(dispatch_block_t)complete;

@end
