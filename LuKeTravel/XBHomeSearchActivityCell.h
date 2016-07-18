//
//  XBHomeSearchCityCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBSearchItem;
@interface XBHomeSearchActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) XBSearchItem  *searchItem;
@end
