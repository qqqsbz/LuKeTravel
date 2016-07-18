//
//  XBHomeSearchFlowLayout.m
//  LuKeTravel
//
//  Created by coder on 16/7/13.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchFlowLayout.h"

@implementation XBHomeSearchFlowLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *original   = [super layoutAttributesForElementsInRect:rect];
    //防止出现警告 没有使用该数组的拷贝对象
    NSArray *attributes = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    CGFloat thresholdX  = CGRectGetWidth(self.collectionView.frame) - self.minimumInteritemSpacing;
    
    for (NSInteger i = 0; i < attributes.count; i ++) {
        
        UICollectionViewLayoutAttributes *attribute = attributes[i];
        
        if (attribute.indexPath.row != 0 && attribute.frame.origin.x > self.minimumInteritemSpacing) {
            
            UICollectionViewLayoutAttributes *previousAttribute = attributes[i - 1];
            
            CGRect attributeRect = attribute.frame;
            
            attributeRect.origin.x = CGRectGetMaxX(previousAttribute.frame) + self.minimumInteritemSpacing;
            
            if (CGRectGetMaxX(attributeRect) > thresholdX) {
                
                attributeRect.origin.x = self.minimumInteritemSpacing;
                
                attributeRect.origin.y += CGRectGetMaxY(attributeRect) - CGRectGetHeight(attributeRect) - self.minimumLineSpacing == CGRectGetMaxY(previousAttribute.frame) ? 0 : self.minimumLineSpacing + CGRectGetHeight(attributeRect);
            
            }
            
            [attribute setFrame:attributeRect];
            
        } else {
        
            NSInteger index = attribute.indexPath.row;
            
            CGRect attributeRect = attribute.frame;
            
            attributeRect.origin.x += self.minimumInteritemSpacing;
            
            if (index - 1 >= 0) {
                
                UICollectionViewLayoutAttributes *previousAttribute = attributes[i - 1];
                
                attributeRect.origin.x += previousAttribute.frame.origin.x == self.minimumInteritemSpacing ? CGRectGetMaxX(previousAttribute.frame) : 0;
                
                if (CGRectGetMaxX(attributeRect) > thresholdX) {
                    
                    attributeRect.origin.x = self.minimumInteritemSpacing;
                
                    attributeRect.origin.y += CGRectGetMaxY(attributeRect) - CGRectGetHeight(attributeRect) - self.minimumLineSpacing == CGRectGetMaxY(previousAttribute.frame) ? 0 : self.minimumLineSpacing + CGRectGetHeight(attributeRect);
                    
                }
                
            }
            
            
            [attribute setFrame:attributeRect];
        }
        
        
//        DDLogDebug(@"indexPath:%@   frame:%@",attribute.indexPath,NSStringFromCGRect(attribute.frame));
    
    }
    return attributes;
}

@end
