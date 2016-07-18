//
//  XBSearch.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearch.h"
#import "XBSearchItem.h"
@implementation XBSearch
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"values":[XBSearchItem class]
             };
}

+ (NSValueTransformer *)valuesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBSearchItem class]];
}

- (void)setValues:(NSArray<XBSearchItem *> *)values
{
    _values = values;
    
    if ([values isKindOfClass:[NSSet class]]) {
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:values.count];
        NSSet *lists = (NSSet *)values;
        [lists enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [temp addObject:obj];
        }];
        _values = temp;
    }
    
}


@end
