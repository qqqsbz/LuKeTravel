//
//  XBCalendarCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBCalendarCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *pitchView;
@property (strong, nonatomic) IBOutlet UILabel *weekLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (assign, nonatomic) BOOL  itemSelected;

@end
