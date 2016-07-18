//
//  XBSearchHot.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchHot.h"
#import "XBSearch.h"
@implementation XBSearchHot
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
    return @{
            };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"items":[XBSearch class]
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBSearch class]];
}

- (void)setItems:(NSArray<XBSearch *> *)items
{
    _items = items;
    
    if ([items isKindOfClass:[NSSet class]]) {
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:items.count];
       
        NSSet *lists = (NSSet *)items;
        
        [lists enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        
            [temp addObject:obj];
        
        }];
        
        _items = temp;
    }
    
}


@end
