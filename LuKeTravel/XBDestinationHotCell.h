//
//  XBDestinationCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBHotDestination;
@interface XBDestinationHotCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView  *coverImageView;
@property (strong, nonatomic) XBHotDestination  *hotDestination;
@property (strong, nonatomic) CAShapeLayer      *shapeLayer;
@end
