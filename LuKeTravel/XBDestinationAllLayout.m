//
//  XBDestinationAllLayout.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestinationAllLayout.h"

@implementation XBDestinationAllLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (NSInteger i = 0; i < attributes.count; i ++) {
        
        UICollectionViewLayoutAttributes *attribute = attributes[i];
    
        if (attribute.indexPath.row != 0 && attribute.frame.origin.x > 0) {
            
            UICollectionViewLayoutAttributes *previousAttribute = attributes[i - 1];
            
            CGRect attributeRect = attribute.frame;
            
            attributeRect.origin.x = CGRectGetMaxX(previousAttribute.frame);
            
            [attribute setFrame:attributeRect];
            
        }
    }

    return attributes;
}

@end
