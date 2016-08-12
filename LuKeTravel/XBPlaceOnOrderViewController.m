//
//  XBPlaceOnOrderViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/10.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kCalendarAnimation  1000

#import "XBPlaceOnOrderViewController.h"
#import "XBPackage.h"
#import "XBOrderCalendarView.h"
@interface XBPlaceOnOrderViewController () <XBOrderCalendarViewDelegate>
/** 活动名称 */
@property (strong, nonatomic) UILabel *nameLabel;
/** 子名称 */
@property (strong, nonatomic) UILabel *subNameLabel;
/** 活动数据 */
@property (strong, nonatomic) XBPackage *package;
/** 毛玻璃效果 */
@property (strong, nonatomic) UIVisualEffectView  *effectView;
/** 日历 */
@property (strong, nonatomic) XBOrderCalendarView *calendarView;
/** 日历positionY */
@property (assign, nonatomic) CGFloat  calendarPositionY;
@end

@implementation XBPlaceOnOrderViewController

- (instancetype)initWithPackage:(XBPackage *)package
{
    if (self = [super init]) {
        _package = package;
        [self buildView];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendarView layoutIfNeeded];
    
    self.calendarPositionY = self.calendarView.layer.position.y;
    
    self.calendarView.layer.position = CGPointMake(self.calendarView.layer.position.x, kCalendarAnimation);
    
    
}

/** 获取活动日历 */
- (void)loadArrangements
{
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] getArrangementsWithPackageId:[self.package.modelId integerValue] success:^(NSArray<XBArrangement *> *arrangements) {
        
        self.calendarView.arrangements = arrangements;
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
    }];
}

- (void)showCalendar
{
    [self loadArrangements];
    
    [self.calendarView layoutIfNeeded];
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    
    springAnimation.damping = 12;
    
    springAnimation.stiffness = 85;
    
    springAnimation.mass = 1;
    
    springAnimation.initialVelocity = 1;
    
    springAnimation.fromValue = @(self.calendarView.layer.position.y);
    
    springAnimation.toValue = @(self.calendarPositionY);
    
    springAnimation.duration = springAnimation.settlingDuration;
    
    springAnimation.removedOnCompletion = NO;
    
    springAnimation.fillMode = kCAFillModeForwards;
    
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    [self.calendarView.layer addAnimation:springAnimation forKey:@"springAnimation"];
    
    
    [UIView animateWithDuration:springAnimation.settlingDuration  delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.nameLabel.alpha = 1;
        
        self.subNameLabel.alpha = 1;
        
    } completion:nil];
}

- (void)buildView
{
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.view addSubview:self.effectView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.alpha = 0;
    self.nameLabel.text = self.package.name;
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:24.f];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
    [self.view addSubview:self.nameLabel];
    
    self.subNameLabel = [UILabel new];
    self.subNameLabel.alpha = 0;
    self.subNameLabel.text = self.package.subName;
    self.subNameLabel.textAlignment = NSTextAlignmentCenter;
    self.subNameLabel.font = [UIFont systemFontOfSize:13.f];
    self.subNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subNameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:self.subNameLabel];
    
    self.calendarView = [XBOrderCalendarView new];
    self.calendarView.delegate = self;
    [self.view addSubview:self.calendarView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kSpace * 3);
        make.left.equalTo(self.view).offset(kSpace * 0.5);
        make.right.equalTo(self.view).offset(-kSpace * 0.5);
    }];
    
    [self.subNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(kSpace * 0.3);
        make.left.equalTo(self.view).offset(kSpace * 0.5);
        make.right.equalTo(self.view).offset(-kSpace * 0.5);
        make.height.mas_equalTo(30);
    }];
    
    [self.calendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.subNameLabel.bottom).offset(kSpace);
    }];
}

- (void)dismissAction
{

    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    
    springAnimation.damping = 12;
    
    springAnimation.stiffness = 85;
    
    springAnimation.mass = 1;
    
    springAnimation.initialVelocity = 1;
    
    springAnimation.fromValue = @(self.calendarPositionY);
    
    springAnimation.toValue = @(kCalendarAnimation);
    
    springAnimation.duration = springAnimation.settlingDuration * 0.4;
    
    springAnimation.removedOnCompletion = NO;
    
    springAnimation.fillMode = kCAFillModeForwards;
    
    springAnimation.delegate = self;
    
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [springAnimation setValue:@"CalendarOutAnimation" forKey:@"CalendarOutAnimation"];
    
    [self.calendarView.layer addAnimation:springAnimation forKey:@"CalendarOutAnimation"];

}

#pragma mark -- CABasicAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    if ([anim valueForKey:@"CalendarOutAnimation"]) {
    
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.nameLabel.alpha = 0.;
            
            self.subNameLabel.alpha = 0;
            
        } completion:nil];

    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim valueForKey:@"CalendarOutAnimation"]) {
        
        UINavigationController *navigationController = self.parentViewController.navigationController;
        
        navigationController.navigationBarHidden = NO;
        
        [self.view removeFromSuperview];
        
        [self removeFromParentViewController];
    }
}

#pragma mark -- XBOrderCalendarViewDelegate
- (void)orderCalendarViewDidSelectDissmiss
{
    [self dismissAction];
}

- (void)orderCalendarView:(XBOrderCalendarView *)orderCalendarView didSelectOrderWithArrangement:(XBArrangement *)arrangement
{
    DDLogDebug(@"arrangement:%@",arrangement);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
