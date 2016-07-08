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
@interface XBHomeActivityCell() <UICollectionViewDelegate,UICollectionViewDataSource>
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
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius  = 7.f;
    cell.groupItem = self.groupItems[indexPath.row];
    return cell;
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
