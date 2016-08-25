//
//  XBhomeDestinationCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kMinimumLineSpacing 10.f

#import "XBHomeDestinationCell.h"
#import "XBGroupItem.h"
#import "XBHomeDestinationContentCell.h"
@interface XBHomeDestinationCell() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *const reuseIdentifier = @"XBHomeDestinationContentCell";
@implementation XBHomeDestinationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate   = self;
    
    self.collectionView.pagingEnabled = YES;
    
    self.collectionView.clipsToBounds = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeDestinationContentCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    
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
    
    XBHomeDestinationContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.groupItem = self.groupItems[indexPath.row];
        
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(homeDestinationCell:didSelectRowWithGroupItem:)]) {
        
        [self.delegate homeDestinationCell:self didSelectRowWithGroupItem:self.groupItems[indexPath.row]];
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){collectionView.xb_width - kMinimumLineSpacing - 0.2,collectionView.xb_height};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinimumLineSpacing;
}


@end
