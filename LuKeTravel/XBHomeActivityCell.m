//
//  XBHomeActivityCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/8.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kMinimumLineSpacing 10.f
#import "XBHomeActivityCell.h"
#import "XBGroupItem.h"
#import "XBHomeActivityContentCell.h"
@interface XBHomeActivityCell() <UICollectionViewDelegate,UICollectionViewDataSource,XBHomeActivityContentCellDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
static NSString *const reuseIdentifier = @"XBHomeActivityContentCell";
static NSString *const headerIdentifier = @"XBActivityHeaderView";
static NSString *const footerIdentifier = @"XBActivityFooterView";
@implementation XBHomeActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.clipsToBounds = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeActivityContentCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XBHomeActivityContentCell"];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, -0.5, 0, -0.5);
}

- (void)setGroupItems:(NSArray<XBGroupItem *> *)groupItems
{
    _groupItems = groupItems;
    
    [self.collectionView layoutIfNeeded];
    
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupItems.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeActivityContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius  = 7.f;
    
    cell.groupItem = self.groupItems[indexPath.row];
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(homeActivityCell:didSelectWithGroupItem:)]) {
        [self.delegate homeActivityCell:self didSelectWithGroupItem:self.groupItems[indexPath.row]];
    }
}

#pragma mark -- XBHomeActivityContentCellDelegate
- (void)homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell didSelectFavoriteWithGroupItem:(XBGroupItem *)groupItem
{
    if ([self.delegate respondsToSelector:@selector(homeActivityCell:homeActivityContentCell:didSelectFavoriteAtIndex:)]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:homeActivityContentCell];
        
        [self.delegate homeActivityCell:self homeActivityContentCell:homeActivityContentCell didSelectFavoriteAtIndex:indexPath.row];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) - kMinimumLineSpacing - 0.2, CGRectGetHeight(self.collectionView.frame));
    flowLayout.minimumLineSpacing = kMinimumLineSpacing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
