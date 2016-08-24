//
//  XBOrderPrePayNavigationBar.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBOrderPrePayNavigationBar : UIView
/** 标题 */
@property (strong, nonatomic) UILabel  *titleLabel;
/** 市场价 */
@property (strong, nonatomic) UILabel  *markerLabel;
/** 现价 */
@property (strong, nonatomic) UILabel  *sellLabel;
/** 日期 */
@property (strong, nonatomic) UILabel  *dateLabel;
/** 张数 */
@property (strong, nonatomic) UILabel  *countLabel;
/** 联系人 */
@property (strong, nonatomic) UILabel *contactNameLabel;
/** 联系电话 */
@property (strong, nonatomic) UILabel *contactPhoneLabel;
/** 电子邮箱 */
@property (strong, nonatomic) UILabel *contactEmailLabel;

- (instancetype)initWithPopBlock:(dispatch_block_t)popBlock;

- (instancetype)initWithFrame:(CGRect)frame popBlock:(dispatch_block_t)popBlock;
@end
