//
//  Model.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface XBModel : MTLModel <MTLJSONSerializing>
/** 将id转换成modelId */
@property(copy, nonatomic) NSString *modelId;

/** 获取数据时的语言 */
@property (strong, nonatomic) NSString *modelLanguage;
@end
