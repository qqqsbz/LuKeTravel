//
//  XBNotifyView.h
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBNotifyView : UIView
/** 图标 */
@property (strong, nonatomic) UIImageView   *imageView;
/** 标题 */
@property (strong, nonatomic) UILabel       *titleLabel;
/** 子标题 */
@property (strong, nonatomic) UILabel       *subTitleLabel;
@end
