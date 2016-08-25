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
@class XBHomeActivityContentCell;

@protocol XBHomeActivityCellDelegate <NSObject>

@optional
/**
 activityCell:当前cell
 groupItem:活动实体对象
 */
- (void)homeActivityCell:(XBHomeActivityCell *)activityCell didSelectWithGroupItem:(XBGroupItem *)groupItem;

- (void)homeActivityCell:(XBHomeActivityCell *)activityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell didSelectFavoriteAtIndex:(NSInteger)index;

@end

@interface XBHomeActivityCell : UITableViewCell
/** 数据对象集合 */
@property (strong, nonatomic) NSArray<XBGroupItem *>  *groupItems;
/** 代理 */
@property (weak, nonatomic) id<XBHomeActivityCellDelegate> delegate;

@end
