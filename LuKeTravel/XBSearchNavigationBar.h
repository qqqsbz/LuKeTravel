//
//  XBSearchView.h
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBSearchNavigationBar;

@protocol XBSearchNavigationBarDelegate <NSObject>

@optional
- (void)searchViewDidSelectedCancle;

- (void)searchViewTextDidChange:(NSString *)text;

- (void)searchViewSearchButtonClicked:(NSString *)text;

- (void)searchViewDidBeginEditing;

- (void)searchViewDidEndEditing;

@end

@interface XBSearchNavigationBar : UIView

@property (weak, nonatomic) id<XBSearchViewDelegate> delegate;

@property (assign, nonatomic) BOOL  becomFirstreSpondent;

@property (strong, nonatomic) NSString  *searchText;

@end
