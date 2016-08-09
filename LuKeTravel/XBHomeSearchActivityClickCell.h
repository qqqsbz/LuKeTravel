//
//  XBHomeSearchActivityClickCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBSearchItem;
@class XBHomeSearchActivityClickCell;

@protocol XBHomeSearchActivityClickCellDelegate <NSObject>

@optional
- (void)searchActivityClickCell:(XBHomeSearchActivityClickCell *)searchActivityClickCell didSelectFavorite:(XBSearchItem *)searchItem;

@end

@interface XBHomeSearchActivityClickCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView        *substanceView;
@property (strong, nonatomic) IBOutlet UIImageView   *coverImageView;
@property (strong, nonatomic) IBOutlet UIView        *pirceView;
@property (strong, nonatomic) IBOutlet UIButton      *favoriteButton;
@property (strong, nonatomic) IBOutlet UILabel       *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel       *sellingPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel       *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *instantImageView;
@property (strong, nonatomic) IBOutlet UILabel       *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *addressImageView;
@property (strong, nonatomic) IBOutlet UILabel       *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *participantsImageView;
@property (strong, nonatomic) IBOutlet UILabel       *participantsLabel;

/** 数据 */
@property (strong, nonatomic) XBSearchItem  *searchItem;

/** 是否收藏  用来修改图标 */
@property (assign, nonatomic) BOOL  favorite;

/** 代理方法 */
@property (weak, nonatomic) id<XBHomeSearchActivityClickCellDelegate> delegate;


@end
