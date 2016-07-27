//
//  XBActivityPackageCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBPackage;
@interface XBActivityPackageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellLabel;
@property (strong, nonatomic) IBOutlet UILabel *markerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pickImageView;
@property (assign, nonatomic) BOOL       pickSelected;
@property (strong, nonatomic) XBPackage  *package;
@end
