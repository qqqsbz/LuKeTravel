//
//  XBMoreActivityViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kCalendarViewHeight 60
#import "XBMoreActivityViewController.h"
#import "XBCalendarView.h"
@interface XBMoreActivityViewController ()
@property (strong, nonatomic) XBCalendarView  *canlendarView;
@end

@implementation XBMoreActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

- (void)buildView
{
    self.canlendarView = [XBCalendarView new];
    self.canlendarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.canlendarView];
    [self.canlendarView loadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.canlendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kCalendarViewHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
