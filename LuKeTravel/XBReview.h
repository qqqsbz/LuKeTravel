//
//  XBReview.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBComment;
@interface XBReview : XBModel
@property (assign, nonatomic) NSInteger  currentPage;
@property (assign, nonatomic) NSInteger  totalPages;
@property (strong, nonatomic) NSArray<XBComment *>  *reviews;
@end