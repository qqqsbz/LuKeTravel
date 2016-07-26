//
//  XBActivityReviewCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBComment;
@interface XBActivityReviewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViews;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorConstraint;
@property (strong, nonatomic) XBComment  *comment;
@end
