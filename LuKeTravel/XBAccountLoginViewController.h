//
//  XBAccountLoginViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/28.
//  Copyright © 2016年 coder. All rights reserved.
//

@interface XBAccountLoginViewController : UIViewController
/** 用户名 */
@property (strong, nonatomic) NSString *userName;
/** 用户是否存在 */
@property (assign, nonatomic) BOOL  userExist;
@end
