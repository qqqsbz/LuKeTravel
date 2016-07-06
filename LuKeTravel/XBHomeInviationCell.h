//
//  XBHomeInviationCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBHomeInviationCellDelegate <NSObject>

- (void)inviationCellDidSelectedClose;

- (void)inviationCellDidSelectedGo;

@end

@class XBInviation;
@interface XBHomeInviationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *inviationButton;

@property (strong, nonatomic) XBInviation  *inviation;
@property (weak, nonatomic) id<XBHomeInviationCellDelegate> delegate;
@end
