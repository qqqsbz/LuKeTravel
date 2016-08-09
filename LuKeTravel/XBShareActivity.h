//
//  XBShareActivity.h
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBShareActivity : XBModel
@property (strong, nonatomic) NSString  *image;
@property (strong, nonatomic) NSString  *subTitle;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *url;

+ (instancetype)shareActivityWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)image url:(NSString *)url;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)image url:(NSString *)url;

@end
