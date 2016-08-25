//
//  XBHomeDestinationContentCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroupItem;
@interface XBHomeDestinationContentCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) XBGroupItem *groupItem;
@end
