//
//  XBPayUseCouponView.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPayUseCouponView.h"
#import "XBPayUseCouponCell.h"
@interface XBPayUseCouponView() <UITableViewDelegate,UITableViewDataSource>
/** 阴影view */
@property (strong, nonatomic) UIView *maskView;
/** 内容view */
@property (strong, nonatomic) UIView *contentView;
/** 导航 */
@property (strong, nonatomic) UIView *navigationView;
/** 兑换View */
@property (strong, nonatomic) UIView *couponView;
/* 兑换 */
@property (strong, nonatomic) UITextField *couponTextField;
/** 兑换按钮 */
@property (strong, nonatomic) UIButton *couponButton;
/** 分割线 */
@property (strong, nonatomic) UIView *separatorView;
/** 列表 */
@property (strong, nonatomic) UITableView *couponTableView;
/** 选中 */
@property (strong, nonatomic) NSIndexPath *selectIndexPath;
@end

static NSString *const reuseIdentifier = @"XBPayUseCouponCell";
@implementation XBPayUseCouponView

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
    
    self.couponView = [UIView new];
    self.couponView.backgroundColor = [UIColor whiteColor];
    self.couponView.layer.masksToBounds = YES;
    self.couponView.layer.cornerRadius  = 7.f;
    self.couponView.layer.borderWidth = 1.f;
    self.couponView.layer.borderColor = [UIColor colorWithHexString:@"#E8E8E8"].CGColor;
    [self.navigationView addSubview:self.couponView];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self.couponView addSubview:self.separatorView];

    self.couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.couponButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-order-prepay-coupon-tocoupon"] forState:UIControlStateNormal];
    [self.couponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.couponButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.couponButton addTarget:self action:@selector(couponAction) forControlEvents:UIControlEventTouchUpInside];
    [self.couponView addSubview:self.couponButton];
    
    self.couponTextField = [UITextField new];
    self.couponTextField.font = [UIFont systemFontOfSize:16.f];
    self.couponTextField.borderStyle = UITextBorderStyleNone;
    self.couponTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.couponTextField.placeholder = [XBLanguageControl localizedStringForKey:@"activity-order-prepay-coupon-input"];
    [self.couponView addSubview:self.couponTextField];
    
    self.couponTableView = [UITableView new];
    self.couponTableView.delegate = self;
    self.couponTableView.dataSource = self;
    self.couponTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.couponTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBPayUseCouponCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.contentView addSubview:self.couponTableView];
    
    self.selectIndexPath = [NSIndexPath indexPathForRow:self.coupons.count - 1 inSection:0];
}

- (void)setCoupons:(NSArray<XBCoupons *> *)coupons
{
    _coupons = coupons;
    
    self.selectIndexPath = [NSIndexPath indexPathForRow:coupons.count - 1 inSection:0];

    [self.couponTableView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.bottom);
        make.height.mas_equalTo(320.f);
    }];
    
    [self.navigationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(65);
    }];
    
    [self.couponView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView).offset(kSpace * 1.2);
        make.right.equalTo(self.navigationView).offset(-kSpace * 1.2);
        make.top.equalTo(self.navigationView).offset(kSpace * 0.9);
        make.bottom.equalTo(self.navigationView).offset(-kSpace * 0.9);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.couponView);
        make.bottom.equalTo(self.couponView);
        make.right.equalTo(self.couponView);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.couponButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.couponView);
        make.top.equalTo(self.couponView);
        make.bottom.equalTo(self.couponView);
        make.width.mas_equalTo(80);
    }];
    
    [self.couponTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.couponView).offset(kSpace);
        make.centerY.equalTo(self.couponView);
        make.right.equalTo(self.couponButton.left).offset(-kSpace * 1.5);
    }];
    
    [self.couponTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.navigationView.bottom);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBPayUseCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.coupons = self.coupons[indexPath.row];
    
    cell.topSeparator.hidden = indexPath.row != 0;
    
    cell.bottomSeparator.hidden = indexPath.row != self.coupons.count - 1;
    
    cell.contentSeparator.hidden = indexPath.row == self.coupons.count - 1;
    
    cell.chechMarkImageView.hidden = indexPath.row != self.selectIndexPath.row;
    
    return cell;
}


#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == self.coupons.count - 1 ? 60 : 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBPayUseCouponCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.chechMarkImageView.hidden = NO;
    
    self.selectIndexPath = indexPath;
    
    if ([self.delegate respondsToSelector:@selector(payUseCouponView:didSelectCouponWithCoupons:)]) {
        
        [self.delegate payUseCouponView:self didSelectCouponWithCoupons:self.coupons[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBPayUseCouponCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.chechMarkImageView.hidden = YES;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    XBPayUseCouponCell *couponCell = (XBPayUseCouponCell *)cell;
//    
//    couponCell.chechMarkImageView.hidden = indexPath.row != self.selectIndexPath.row;
//    
//}


- (void)toggle
{
    [self layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    if (self.contentView.xb_y == self.xb_height) {
        
        self.alpha = 1.;
        
        [self reloadData];
        
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

- (void)reloadData
{
    [self.couponTableView reloadData];
    
    [self.couponTableView selectRowAtIndexPath:self.selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
}


- (void)couponAction
{
    if ([self.delegate respondsToSelector:@selector(payUseCouponView:didSelectRedeemWithCode:)]) {
        
        [self.delegate payUseCouponView:self didSelectRedeemWithCode:self.couponTextField.text];
    }
}

- (UIView *)payUseContentView
{
    return self.contentView;
}

- (void)dismissAction
{
    [self toggle];
}


@end
