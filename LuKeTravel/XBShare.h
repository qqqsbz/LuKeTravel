//
//  XBShare.h
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBShare : NSObject

/** 名称 */
@property (strong, nonatomic) NSString  *name;
/** 图标 */
@property (strong, nonatomic) UIImage   *icon;
/** 平台 */
@property (strong, nonatomic) NSString  *plantform;

+ (instancetype)shareWithName:(NSString *)name icon:(UIImage *)icon plantform:(NSString *)plantform;

- (instancetype)initWithName:(NSString *)name icon:(UIImage *)icon plantform:(NSString *)plantform;

@end
