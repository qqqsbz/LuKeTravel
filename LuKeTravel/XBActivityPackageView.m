//
//  XBActivityToolBar.m
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kActivityToolBarHeight 50.f
#define kShowY  self.xb_height - self.tableView.xb_height - kActivityToolBarHeight

#import "XBActivityPackageView.h"
#import "XBActivityPackageCell.h"
@interface XBActivityPackageView() <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIView        *maskView;
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) UIView        *separatorView;
@property (strong, nonatomic) UIView        *menuView;
@property (assign, nonatomic) BOOL          showPackage;
@property (strong, nonatomic) UIButton      *packageButton;
@property (strong, nonatomic) NSIndexPath   *selectedIndexPath;
@end


static NSString *const reuseIdentifier = @"XBActivityPackageCell";
@implementation XBActivityPackageView

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
    self.backgroundColor = [UIColor clearColor];
    
    self.menuView = [UIView new];
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.menuView];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self.menuView addSubview:self.separatorView];
    
    self.packageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.packageButton.enabled = NO;
    self.packageButton.layer.masksToBounds = YES;
    self.packageButton.layer.cornerRadius  = 8.f;
    self.packageButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.packageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.packageButton setTitle:NSLocalizedString(@"activity-detail-package-normal", @"activity-detail-package-normal") forState:UIControlStateNormal];
    [self.packageButton setTitleColor:[UIColor colorWithWhite:1.f alpha:0.85] forState:UIControlStateNormal];
    [self.packageButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.packageButton addTarget:self action:@selector(packageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.packageButton];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65f];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
    [self addSubview:self.maskView];
    [self sendSubviewToBack:self.maskView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.xb_height, self.xb_width, 0)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBActivityPackageCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self insertSubview:self.tableView belowSubview:self.menuView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.menuView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(kActivityToolBarHeight);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuView);
        make.top.equalTo(self.menuView);
        make.right.equalTo(self.menuView);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.packageButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuView).offset(kSpace * 2.5);
        make.right.equalTo(self.menuView).offset(-kSpace * 2.5);
        make.top.equalTo(self.menuView).offset(kSpace * 0.7);
        make.bottom.equalTo(self.menuView).offset(-kSpace * 0.7);
    }];
    
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.bottom);
        make.height.mas_equalTo(70.f);
    }];
}

- (void)setPackages:(NSArray<XBPackage *> *)packages
{
    _packages = packages;
    
    self.packageButton.enabled = YES;
    
    [self.tableView reloadData];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.packages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBActivityPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.package = self.packages[indexPath.row];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBActivityPackageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.pickSelected = YES;
    
    self.selectedIndexPath = indexPath;
    
    [self.packageButton setTitle:NSLocalizedString(@"activity-detail-package-select", @"activity-detail-package-select") forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBActivityPackageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.pickSelected = NO;
}


- (void)packageAction
{
    if (!self.showPackage) {
        
        //开始动画
        if ([self.delegate respondsToSelector:@selector(activityPackageView:didShowPackageWithButton:)]) {
            [self.delegate activityPackageView:self didShowPackageWithButton:self.packageButton];
        }
        
        [self.tableView layoutIfNeeded];
        
        BOOL isFill = self.packages.count * 70.f > (self.xb_height - self.maxTop);
        
        CGFloat height = isFill ? self.xb_height - self.maxTop : self.packages.count * 70.f;
        
        self.tableView.xb_height = height;
        
        self.tableView.scrollEnabled = isFill;
        
        [self.superview bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.tableView.xb_y = kShowY;
            
        } completion:^(BOOL finished) {
            
            self.showPackage = YES;
            
        }];
    }
    
    if (self.selectedIndexPath) {
        
        if ([self.delegate respondsToSelector:@selector(activityPackageView:didSelectPackageWithPackage:)]) {
            
            [self.delegate activityPackageView:self didSelectPackageWithPackage:self.packages[self.selectedIndexPath.row]];
            
        }
    }
}

- (void)dismissAction
{
    //结束动画
    if ([self.delegate respondsToSelector:@selector(activityPackageView:didHidePackageWithButton:)]) {
        [self.delegate activityPackageView:self didHidePackageWithButton:self.packageButton];
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.tableView.xb_y = self.xb_height;
        
    } completion:^(BOOL finished) {
        
        [self.superview sendSubviewToBack:self];
        
        self.showPackage = NO;
        
        XBActivityPackageCell *cell = (XBActivityPackageCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
        
        cell.selected = NO;
        
        self.selectedIndexPath = nil;
        
        [self.packageButton setTitle:NSLocalizedString(@"activity-detail-package-normal", @"activity-detail-package-normal") forState:UIControlStateNormal];
        
    }];
}

@end
