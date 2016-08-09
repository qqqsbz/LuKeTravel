//
//  XBSearchItem.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchItem.h"
#import "XBWishlist.h"
@implementation XBSearchItem
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"modelId":@"id",
             @"marketPrice":@"market_price",
             @"sellingPrice":@"selling_price",
             @"hotState":@"hot_state",
             @"participantsFormat":@"participants_format",
             @"cityName":@"city_name",
             @"subName":@"subname",
             @"imageUrl":@"image_url"
             };
}

+ (XBSearchItem *)searchItemFromWishlist:(XBWishlist *)wishlist
{
    XBSearchItem *searchItem = [[XBSearchItem alloc] init];
    
    searchItem.imageUrl = wishlist.thumbUrl;
    
    searchItem.name = wishlist.name;
    
    searchItem.subName = wishlist.subName;
    
    searchItem.cityName = wishlist.destinationName;
    
    searchItem.currency = wishlist.currency;
    
    searchItem.participants = wishlist.participants;
    
    searchItem.marketPrice = wishlist.marketPrice;
    
    searchItem.sellingPrice = wishlist.sellPrice;
    
    searchItem.instant = wishlist.isInstant;
    
    searchItem.video = wishlist.isVideo;
    
    searchItem.favorite = wishlist.isFavourite;
    
    searchItem.hotState = wishlist.hotState;
    
    searchItem.participantsFormat = wishlist.participantsFormat;
    
    searchItem.modelId = wishlist.modelId;
    
    return searchItem;
}

@end
