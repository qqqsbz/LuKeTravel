//
//  XBPlainFlowLayout.h
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 处理当分组时 header view 能像UITableView header view 一样悬浮 */
@interface XBPlainFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat naviHeight;//默认为64.0, default is 64.0

@end
