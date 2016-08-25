//
//  XBNavigationController.m
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBNavigationController.h"

@interface XBNavigationController ()

@end

@implementation XBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)popAction
{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
