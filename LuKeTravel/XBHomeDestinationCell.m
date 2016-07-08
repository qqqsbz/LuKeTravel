//
//  XBHomeDestinationCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kSpace 10.f
#define kPreviewCount 2       //预先加载两个
#import "XBHomeDestinationCell.h"
#import "XBHomeDestinationView.h"
@interface XBHomeDestinationCell() <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger             currentPage;
@end
@implementation XBHomeDestinationCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDestinations:(NSArray<XBGroupItem *> *)destinations
{
    _destinations = destinations;
    
    NSInteger count = destinations.count;
    
    [self.scrollView layoutIfNeeded];
    
    self.currentPage = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    
    CGFloat width = CGRectGetWidth(self.scrollView.frame) - kSpace ;
    
    CGFloat height = CGRectGetHeight(self.scrollView.frame) - kSpace;
    
    CGFloat x = 0;
    
    //创建控件
    if (self.scrollView.subviews.count < self.destinations.count) {
        for (NSInteger i = 0; i < count; i ++) {
            
            x = i == 0 ? 0 : width * i + kSpace * i;
            
            [self buildActivityWithRect:CGRectMake(x, kSpace, width, height) atIndex:i];
            
        }
    }
    
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
    XBHomeDestinationView *destinationView = [[XBHomeDestinationView alloc] initWithFrame:frame];
    
    destinationView.tag = index;
    
    destinationView.backgroundColor = [UIColor whiteColor];
    
    destinationView.layer.masksToBounds = YES;
    
    destinationView.layer.cornerRadius  = 7.f;
    
    [destinationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    [self.scrollView addSubview:destinationView];
}

- (void)fillContentFromPage:(NSInteger)page
{
    if (page < self.scrollView.subviews.count) {
        //设置内容
        XBGroupItem *groupItem = self.destinations[page];
        
        XBHomeDestinationView *destinationView = self.scrollView.subviews[page];
        
        destinationView.destination = groupItem;
        
        //查看是否有缓存
        BOOL isCache  = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:groupItem.imageUrl] ||[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:groupItem.imageUrl];
        
        //没有缓存则 下载图片并进行缓存
        if (!isCache) {
            
            [destinationView.coverImageView sd_setImageWithURL:[NSURL URLWithString:groupItem.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL.absoluteString];
                
            }];
            
        } else {
            
            //优先从内存中读取缓存 如果内存中没有缓存则读取磁盘
            UIImage *cacheImage;
            if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:groupItem.imageUrl]) {
                
                cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:groupItem.imageUrl];
                
            } else {
                
                cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:groupItem.imageUrl];
                
            }
            
            destinationView.coverImageView.image = cacheImage;
            
        }
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
    if ([self.delegate respondsToSelector:@selector(destinationCell:didSelectedDestinationWithGroupItem:)]) {
        [self.delegate destinationCell:self didSelectedDestinationWithGroupItem:self.destinations[tapGesture.view.tag]];
    }
}

@end
