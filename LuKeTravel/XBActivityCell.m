//
//  XBHomeActivityCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kPreviewCount 2       //预先加载两个
#import "XBActivityCell.h"
#import "XBGroupItem.h"
#import "XBHomeActivityView.h"
#import "XBHomeDestinationView.h"
#import <SDImageCache.h>
@interface XBActivityCell() <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger             currentPage;
@end
@implementation XBActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;       //不允许在边缘拉伸
    self.scrollView.clipsToBounds = NO; //显示未在显示区域的子view
    self.scrollView.backgroundColor = [UIColor clearColor];
}

- (void)setActivities:(NSArray<XBGroupItem *> *)activities
{
    _activities = activities;
    
    NSInteger count = activities.count;
    
    [self.scrollView layoutIfNeeded];
    
    self.currentPage = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    
    CGFloat width = CGRectGetWidth(self.scrollView.frame) - kSpace ;
    
    CGFloat height = CGRectGetHeight(self.scrollView.frame) - kSpace;
    
    CGFloat x = 0;
    
    //创建控件
    if (self.scrollView.subviews.count < self.activities.count) {
        for (NSInteger i = 0; i < count; i ++) {
            
            x = i == 0 ? 0 : width * i + kSpace * i;
            
            [self buildActivityWithRect:CGRectMake(x, kSpace, width, height) atIndex:i];
            
        }
    } else {
        
        for (NSInteger i = self.activities.count; i < self.scrollView.subviews.count; i ++) {
            
            XBHomeActivityView *activityView = self.scrollView.subviews[i];
            
            [activityView removeFromSuperview];
            
        }
        
    }
    
    self.currentPage = 0;
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
    
    [self scrollToPage];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.scrollView.subviews lastObject].frame), height);
}

- (void)scrollToPage
{
    for (NSInteger i = self.currentPage; i < self.currentPage + kPreviewCount; i ++) {
        [self fillContentFromPage:i];
    }
}

- (void)buildActivityWithRect:(CGRect)frame atIndex:(NSInteger)index
{
    XBHomeActivityView *activityView = [[XBHomeActivityView alloc] initWithFrame:frame];
    
    activityView.tag = index;
    
    activityView.backgroundColor = [UIColor whiteColor];
    
    activityView.layer.masksToBounds = YES;
    
    activityView.layer.cornerRadius  = 7.f;
    
    [activityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    [self.scrollView addSubview:activityView];
}

- (void)fillContentFromPage:(NSInteger)page
{
    if (page < self.activities.count) {
        //设置内容
        XBGroupItem *groupItem = self.activities[page];
        
        XBHomeActivityView *activityView = self.scrollView.subviews[page];
        
        activityView.groupItem = groupItem;
        
    }
}

#pragma mark -- UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (self.currentPage != page) {
        self.currentPage = page;
        [self scrollToPage];
    }
    
}


- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(activityCell:didSelectedActivityWithGroupItem:)]) {
        [self.delegate activityCell:self didSelectedActivityWithGroupItem:self.activities[tapGesture.view.tag]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
