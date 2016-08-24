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
- (void)searchNavigationBarDidSelectedCancle;

- (void)searchNavigationBarTextDidChange:(NSString *)text;

- (void)searchNavigationBarSearchButtonClicked:(NSString *)text;

- (void)searchNavigationBarDidBeginEditing;

- (void)searchNavigationBarDidEndEditing;

@end

@interface XBSearchNavigationBar : UIView

@property (weak, nonatomic) id<XBSearchNavigationBarDelegate> delegate;

@property (assign, nonatomic) BOOL  becomFirstreSpondent;

@property (strong, nonatomic) NSString  *searchText;

@end
