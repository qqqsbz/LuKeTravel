//
//  XBShareActivity.m
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBShareActivity.h"

@implementation XBShareActivity

+ (instancetype)shareActivityWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)image url:(NSString *)url
{
    return [[self alloc] initWithTitle:title subTitle:subTitle image:image url:url];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)image url:(NSString *)url
{
    if (self = [super init]) {
        _title = title;
        _subTitle = subTitle;
        _image = image;
        _url = url;
    }
    return self;
}

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
    return @{@"subTitle":@"sub_title"
             };
}
@end
