//
//  XBParserContentItem.h
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XBRange;
@interface XBParserContentItem : NSObject
@property (strong, nonatomic) NSString  *linkString;
@property (strong, nonatomic) XBRange   *range;
@property (strong, nonatomic) NSString  *text;
@end
