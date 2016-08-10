//
//  XBActivityDetailViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

@class XBParserContent;
@interface XBActivityDetailViewController : UIViewController

- (instancetype)initWithParserContents:(NSArray<XBParserContent *> *)parserContents navigationTitle:(NSString *)title;

@end
