//
//  XBhomeDestinationCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroupItem;
@class XBHomeDestinationCell;

@protocol XBHomeDestinationCellDelegate <NSObject>

@optional
- (void)homeDestinationCell:(XBHomeDestinationCell *)homeDestinationCell didSelectRowWithGroupItem:(XBGroupItem *)groupItem;

@end

@interface XBHomeDestinationCell : UITableViewCell

/** 代理 */
@property (weak, nonatomic) id<XBHomeDestinationCellDelegate> delegate;
/** 数据集合 */
@property (strong, nonatomic) NSArray<XBGroupItem *> *groupItems;

@end
