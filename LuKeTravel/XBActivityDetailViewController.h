//
//  XBActivityDetailViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBasicViewController.h"
@class XBParserContent;
@interface XBActivityDetailViewController : XBBasicViewController

- (instancetype)initWithParserContents:(NSArray<XBParserContent *> *)parserContents navigationTitle:(NSString *)title;

@end
