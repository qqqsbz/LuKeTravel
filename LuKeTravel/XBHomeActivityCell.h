//
//  XBHomeActivityCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroupItem;
@class XBHomeActivityCell;
@protocol XBHomeActivityCellDelegate <NSObject>

@optional
/**
 activityCell:当前cell
 groupItem:活动实体对象
 */
- (void)activityCell:(XBHomeActivityCell *)activityCell didSelectedWithGroupItem:(XBGroupItem *)groupItem;

@end

@interface XBHomeActivityCell : UITableViewCell
@property (strong, nonatomic) NSArray<XBGroupItem *>  *groupItems;
@property (weak, nonatomic) id<XBHomeActivityCellDelegate> delegate;
@end
