//
//  XBHomeActivityCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroupItem;
@interface XBHomeActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) NSArray<XBGroupItem *>  *activities;
@property (strong, nonatomic) NSArray<XBGroupItem *>  *destination;
@end
