//
//  XBOrderBookCell.h
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBOrderBookPrice;
@class XBOrderBookCell;
@protocol XBOrderBookCellDelegate <NSObject>

@optional
- (void)orderBookCell:(XBOrderBookCell *)orderBookCell didSelectCountWithOrderBookPrice:(XBOrderBookPrice *)orderBookPrice isPlus:(BOOL)isPlus;

- (void)orderBookCell:(XBOrderBookCell *)orderBookCell exceedMax:(NSInteger)max;

@end

@interface XBOrderBookCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellLabel;
@property (strong, nonatomic) IBOutlet UILabel *markLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;

@property (strong, nonatomic) XBOrderBookPrice *orderBookPrice;

@property (weak, nonatomic) id<XBOrderBookCellDelegate> delegate;
@end
