//
//  XBOrderBookView.h
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBOrderBook;
@class XBOrderBookView;

@protocol XBOrderBookViewDelegate <NSObject>

@optional
- (void)orderBookView:(XBOrderBookView *)orderBookView exceedMax:(NSInteger)max;

- (void)orderBookView:(XBOrderBookView *)orderBookView bookOrderWithParams:(NSArray<NSNumber *> *)params;

@end

@interface XBOrderBookView : UIView
/** 数据对象 */
@property (strong, nonatomic) XBOrderBook *orderBook;

/** 预订时间 */
@property (strong, nonatomic) NSString *bookDate;

/** 代理 */
@property (weak, nonatomic) id<XBOrderBookViewDelegate> delegate;

@end
