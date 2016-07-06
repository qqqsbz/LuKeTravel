//
//  XBHomeActivityCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#import "XBHomeActivityCell.h"
#import "XBGroupItem.h"
#import "XBHomeActivityView.h"
#import "XBHomeDestinationView.h"
@interface XBHomeActivityCell() <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation XBHomeActivityCell

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
    
    CGFloat width = CGRectGetWidth(self.scrollView.frame) - kSpace ;
    
    CGFloat height = CGRectGetHeight(self.scrollView.frame) - kSpace;
    
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < count; i ++) {

        x = i == 0 ? 0 : width * i + kSpace * i;
        
       [self buildActivityWithRect:CGRectMake(x, kSpace, width, height) atIndex:i];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.scrollView.subviews lastObject].frame) - kSpace, height);
}

- (void)setDestination:(NSArray<XBGroupItem *> *)destination
{
    _destination = destination;
    
    NSInteger count = destination.count;
    
    [self.scrollView layoutIfNeeded];
    
    CGFloat width = CGRectGetWidth(self.scrollView.frame) - kSpace ;
    
    CGFloat height = CGRectGetHeight(self.scrollView.frame) - kSpace;
    
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        x = i == 0 ? 0 : width * i + kSpace * i;
        
        [self buildDestinationWithRect:CGRectMake(x, kSpace, width, height) atIndex:i];
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.scrollView.subviews lastObject].frame) - kSpace, height);

}

- (void)buildActivityWithRect:(CGRect)frame atIndex:(NSInteger)index
{
    XBHomeActivityView *activityView = [[XBHomeActivityView alloc] initWithFrame:frame];
    
    activityView.backgroundColor = [UIColor whiteColor];
    
    activityView.tag = index;
    
    activityView.groupItem = self.activities[index];
    
    activityView.layer.masksToBounds = YES;
    
    activityView.layer.cornerRadius  = 7.f;
    
    [self.scrollView addSubview:activityView];
}

- (void)buildDestinationWithRect:(CGRect)frame atIndex:(NSInteger)index
{
    XBHomeDestinationView *destinationView = [[XBHomeDestinationView alloc] initWithFrame:frame];
    
    destinationView.backgroundColor = [UIColor whiteColor];
    
    destinationView.tag = index;
    
    destinationView.destination = self.destination[index];
    
    [self.scrollView addSubview:destinationView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
