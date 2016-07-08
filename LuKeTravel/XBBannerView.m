//
//  XBBannerView.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#import "XBBannerView.h"
@interface XBBannerView() <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) UIPageControl     *pageControl;
@end
@implementation XBBannerView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.scrollView = [UIScrollView new];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.pageControl = [UIPageControl new];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#949087"];
    [self addSubview:self.pageControl];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _imageUrls = imageUrls;
    
    self.pageControl.numberOfPages = imageUrls.count;
    
    for (NSInteger i = 0; i < self.imageUrls.count; i ++) {
        
        UIImageView *imageView = [UIImageView new];
        
        imageView.tag = i;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[i]]];
        
        [self.scrollView addSubview:imageView];
    }
    
    NSArray *subviews = self.scrollView.subviews;
    
    UIImageView *firstImageView = [subviews firstObject];
    
    UIImageView *lastImageView  = [subviews lastObject];
    
    [firstImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [lastImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.width.equalTo(firstImageView);
    }];
    
    for (NSInteger i = 1; i <= subviews.count - 1; i ++) {
        
        UIImageView *currentImageView  = subviews[i];
        
        UIImageView *previousImageView = subviews[i - 1];
        
        [currentImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousImageView.right);
            make.height.equalTo(previousImageView);
            make.width.equalTo(previousImageView);
        }];
        
    }
    

    [lastImageView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastImageView.frame), CGRectGetHeight(self.scrollView.frame));

}

#pragma mark -- UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
}



@end
