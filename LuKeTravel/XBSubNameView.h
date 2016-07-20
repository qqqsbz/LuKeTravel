//
//  XBSubNameView.h
//  LuKeTravel
//
//  Created by coder on 16/7/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBMoreActivitySubName;
@class XBMoreActivitySubNameItem;
@class XBSubNameView;

@protocol XBMoreActivitySubNameDelegate <NSObject>

@optional
- (void)subNameView:(XBSubNameView *)subNameView didSelectedWithSubNameItem:(XBMoreActivitySubNameItem *)item;

@end

@interface XBSubNameView : UIView

@property (strong, nonatomic) XBMoreActivitySubName  *subName;

@property (weak, nonatomic) id<XBMoreActivitySubNameDelegate> delegate;

@end
