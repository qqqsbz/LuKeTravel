//
//  XBHomeHeaderCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroup;
@class XBHomeHeaderCell;

@protocol XBHomeHeaderCellDelegate <NSObject>

@optional
- (void)homeHeaderCell:(XBHomeHeaderCell *)homeHeaderCell didSelectCityWithCityId:(NSInteger)cityId;

@end

@interface XBHomeHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *subTitleButton;

/** 数据对象 */
@property (strong, nonatomic) XBGroup *group;
/** 代理 */
@property (weak, nonatomic) id<XBHomeHeaderCellDelegate> delegate;
@end