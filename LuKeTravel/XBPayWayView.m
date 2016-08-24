//
//  XBPayWayView.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPayWayView.h"
#import "XBPayWay.h"
#import "XBPayWayCell.h"
@interface XBPayWayView() <UITableViewDelegate,UITableViewDataSource>
/** 阴影view */
@property (strong, nonatomic) UIView *maskView;
/** 内容view */
@property (strong, nonatomic) UIView *contentView;
/** 导航 */
@property (strong, nonatomic) UIView *navigationView;
/** 隐藏按钮 */
@property (strong, nonatomic) UIButton *cancleButton;
/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 支付方式 */
@property (strong, nonatomic) UITableView *paywayTableView;
/** 数据 */
@property (strong, nonatomic) NSArray<XBPayWay *> *datas;
@end

static NSString *const paywayReuseIdentifier = @"XBPayWayCell";
@implementation XBPayWayView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    
    self.datas = @[
                   [XBPayWay payWayWithTitle:[XBLanguageControl localizedStringForKey:@"activity-order-prepay-option-alipay"] icon:[UIImage imageNamed:@"alipay"] payWay:kPayWayAliPay],
                   [XBPayWay payWayWithTitle:[XBLanguageControl localizedStringForKey:@"activity-order-prepay-option-wechatpay"] icon:[UIImage imageNamed:@"wechatPay"] payWay:kPayWayWechatPay]
                   ];
    
    self.alpha = 0;
    
    self.maskView = [UIView new];
    self.maskView.userInteractionEnabled = YES;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
    [self addSubview:self.maskView];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.navigationView = [UIView new];
    self.navigationView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.contentView addSubview:self.navigationView];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.cancleButton];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-prepay-option-title"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#818181"];
    [self.navigationView addSubview:self.titleLabel];
    
    self.paywayTableView = [UITableView new];
    self.paywayTableView.delegate = self;
    self.paywayTableView.dataSource = self;
    self.paywayTableView.backgroundColor = [UIColor whiteColor];
    self.paywayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.paywayTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBPayWayCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:paywayReuseIdentifier];
    [self.contentView addSubview:self.paywayTableView];
    
    [self.paywayTableView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.bottom);
        make.height.mas_equalTo(320.f);
    }];
    
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.navigationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.cancleButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationView);
        make.left.equalTo(self.navigationView).offset(kSpace * 1.5);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigationView);
    }];
    
    [self.paywayTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.navigationView.bottom);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark -- UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:paywayReuseIdentifier forIndexPath:indexPath];
    
    XBPayWay *payWay = self.datas[indexPath.row];
    
    cell.iconImageView.image = payWay.icon;
    
    cell.titleLabel.text = payWay.title;
    
    cell.checkMarkImageView.hidden = YES;
    
    return cell;
}

#pragma mark -- UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBPayWayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.checkMarkImageView.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(payWayView:didSelectWithPayWay:)]) {
        
        [self.delegate payWayView:self didSelectWithPayWay:self.datas[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBPayWayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.checkMarkImageView.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)toggle
{
    [self layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    if (self.contentView.xb_y == self.xb_height) {
        
        self.alpha = 1.;
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.contentView.xb_y = self.xb_height - self.contentView.xb_height;
            
            self.maskView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            self.contentView.xb_y = self.xb_height - self.contentView.xb_height;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

            self.contentView.xb_y = self.xb_height;
            
            self.maskView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.alpha = 0.;
            
        }];
        
    }
}

- (UIView *)payWayContentView
{
    return self.contentView;
}

- (void)dismissAction
{
    [self toggle];
}

@end
