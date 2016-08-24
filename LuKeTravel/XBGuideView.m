//
//  XBGuideView.m
//  LuKeTravel
//
//  Created by coder on 16/8/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBGuideView.h"
#import "XBGuideContentView.h"
@interface XBGuideView() <UIScrollViewDelegate>
/** 引导图片 */
@property (strong, nonatomic) NSArray<UIImage *> *images;
/** 标题 */
@property (strong, nonatomic) NSArray<NSString *> *titles;
/** 内容 */
@property (strong, nonatomic) NSArray<NSString *> *contents;
/** 滚动页 */
@property (strong, nonatomic) UIScrollView *scrollView;
/** 分页 */
@property (strong, nonatomic) UIPageControl *pageControl;
/** 开始按钮 */
@property (strong, nonatomic) UIButton *startButton;
/** 完成回调 */
@property (copy  , nonatomic) dispatch_block_t  complete;
/** 图片集合 */
@property (strong, nonatomic) NSMutableArray<XBGuideContentView *> *contentViews;
@end
@implementation XBGuideView

- (instancetype)initWitImages:(NSArray<UIImage *> *)images titles:(NSArray<NSString *> *)titles contents:(NSArray<NSString *> *)contents complete:(dispatch_block_t)complete
{
    if (self = [super init]) {
        _images = images;
        _titles = titles;
        _contents = contents;
        _complete = complete;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images titles:(NSArray<NSString *> *)titles contents:(NSArray<NSString *> *)contents complete:(dispatch_block_t)complete
{
    if (self = [super initWithFrame:frame]) {
        _images = images;
        _titles = titles;
        _contents = contents;
        _complete = complete;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.scrollView = [UIScrollView new];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.bounces = NO;
    
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
    
    self.pageControl = [UIPageControl new];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.75];
    
    self.pageControl.numberOfPages = self.titles.count;
    
    self.pageControl.currentPage = 0;
    
    self.pageControl.userInteractionEnabled = NO;
    
    [self addSubview:self.pageControl];
    
    self.contentViews = [NSMutableArray arrayWithCapacity:self.images.count];
    
    for (NSInteger i = 0; i < self.images.count; i ++) {
        
        XBGuideContentView *contentView = [[XBGuideContentView alloc] initWithJumpBlock:^{
            
            [self guideComplete];
        }];
        
        contentView.imageView.image = self.images[i];
        
        contentView.hideJump = i == self.images.count - 1;
        
        contentView.contentLabel.text = self.contents[i];
        
        contentView.titleLabel.text = self.titles[i];
        
        [self.contentViews addObject:contentView];
        
        [self.scrollView addSubview:contentView];
    }
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.startButton.layer.masksToBounds = YES;
    
    self.startButton.layer.cornerRadius  = 19.f;
    
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    
    self.startButton.backgroundColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    [self.startButton setTitle:[XBLanguageControl localizedStringForKey:@"guide-start"] forState:UIControlStateNormal];
    
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.startButton addTarget:self action:@selector(guideComplete) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.startButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kSpace * 2.7);
    }];
    
    XBGuideContentView *firstContentView = [self.contentViews firstObject];
    
    XBGuideContentView *lastContentView = [self.contentViews lastObject];
    
    [firstContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.equalTo(self.width);
        make.height.equalTo(self.height);
    }];
    
    [lastContentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.equalTo(firstContentView);
        make.height.equalTo(firstContentView);
    }];
    
    for (NSInteger i = 1; i < self.contentViews.count; i ++) {
        
        XBGuideContentView *currentContentView = self.contentViews[i];
        
        XBGuideContentView *previousContentView = self.contentViews[i - 1];
        
        [currentContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousContentView.right);
            make.top.equalTo(self.scrollView);
            make.height.equalTo(previousContentView);
            make.width.equalTo(previousContentView);
        }];
    }
    
    [self.startButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lastContentView);
        make.bottom.equalTo(lastContentView).offset(-kSpace * 2.5);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(38.f);
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.xb_width * self.contentViews.count, self.scrollView.xb_height);
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.xb_width;
    
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    CGFloat targetX = self.xb_width * (self.contentViews.count - 2);
    
    self.pageControl.alpha = contentOffsetX >= targetX ? 1 - (contentOffsetX - targetX) / targetX * 1.5 : (self.pageControl.alpha == 1 ? 1 : (targetX - contentOffsetX) / self.xb_width * 0.5);
}

- (void)guideComplete
{
    if (self.complete) {
        
        self.complete();
    }
}

@end
