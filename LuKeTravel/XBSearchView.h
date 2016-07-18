//
//  XBSearchView.h
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBSearchView;

@protocol XBSearchViewDelegate <NSObject>

@optional
- (void)searchViewDidSelectedCancle;

- (void)searchViewTextDidChange:(NSString *)text;

- (void)searchViewSearchButtonClicked:(NSString *)text;

- (void)searchViewDidBeginEditing;

- (void)searchViewDidEndEditing;

@end

@interface XBSearchView : UIView

@property (weak, nonatomic) id<XBSearchViewDelegate> delegate;

@property (assign, nonatomic) BOOL  becomFirstreSpondent;

@property (strong, nonatomic) NSString  *searchText;

@end
