//
//  Constants.h
//  iPenYou
//
//  Created by trgoofi on 14-5-15.
//  Copyright (c) 2014年 vbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kErrorDomain;                    //NSError Domain

extern NSString *const kDefaultColorHex;                //默认主色调颜色

extern NSString *const kTypeOfActivity;                 //结果为"活动"

extern NSString *const kTypeOfCity;                     //结果为"城市"

extern NSString *const kParserTitleSingleTag;           //判断是否为标题 如:*

extern NSString *const kParserTitleMultipleTag;         //判断是否为标题 如:**

extern NSString *const kWebSiteRegex;                   //网址正则表达式

//@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"