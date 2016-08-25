//
//  XBHomeActivityContentCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroupItem;
@class XBHomeActivityContentCell;

@protocol XBHomeActivityContentCellDelegate <NSObject>

@optional
- (void)homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell didSelectFavoriteWithGroupItem:(XBGroupItem *)groupItem;

@end

@interface XBHomeActivityContentCell : UICollectionViewCell
/** 数据对象 */
@property (strong, nonatomic) XBGroupItem   *groupItem;
/** 是否收藏 */
@property (assign, nonatomic) BOOL  favorite;
/** 代理 */
@property (weak, nonatomic) id<XBHomeActivityContentCellDelegate> delegate;

/** 开始收藏动画 */
- (void)startFavoriteAnimation;
@end
