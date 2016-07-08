//
//  XBHomeDestinationCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBHomeDestinationCell;
@class XBGroupItem;
@protocol XBHomeDestinationCellDelegate <NSObject>

@optional
- (void)destinationCell:(XBHomeDestinationCell *)destinationCell didSelectedDestinationWithGroupItem:(XBGroupItem *)groupItem;
@end

@interface XBHomeDestinationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) NSArray<XBGroupItem *>  *destinations;
@property (weak, nonatomic) id<XBHomeDestinationCellDelegate> delegate;
@end
