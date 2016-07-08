//
//  XBHomeActivityCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBActivityCell;
@class XBGroupItem;
@protocol XBActivityCellDelegate <NSObject>

@optional
- (void)activityCell:(XBActivityCell *)activityCell didSelectedActivityWithGroupItem:(XBGroupItem *)groupItem;

@end

@interface XBActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) NSArray<XBGroupItem *>  *activities;
@property (weak, nonatomic) id<XBActivityCellDelegate> delegate;
@end
