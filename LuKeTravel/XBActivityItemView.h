//
//  XBActivityItemView.h
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBParserContentItem;
@class XBActivityItemView;

@protocol XBActivityItemViewDelegate <NSObject>

@optional
- (void)activityItemView:(XBActivityItemView *)activityItemView didSelectLinkWithURL:(NSURL *)url;

@end

@interface XBActivityItemView : UIView

@property (strong, nonatomic) XBParserContentItem  *parserContentItem;

@property (weak, nonatomic) id<XBActivityItemViewDelegate> delegate;

@end
