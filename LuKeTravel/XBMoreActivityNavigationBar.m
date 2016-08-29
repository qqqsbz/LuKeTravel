//
//  XBNavigationBar.m
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//
//#define kCalendarViewHeight  60
//#define kNavigationBarHeight 64
#define kNavigationBarHeight 64.f
#define kLevelOneRowHeight   55.f
#define kSortRowHeight       44.f
#define kOpenDuration        0.15
#define kCloseDuration       0.15
#define kNavigationBarFooterHeight 45.f

#import "XBMoreActivityNavigationBar.h"
#import "XBLevelOne.h"
#import "XBCalendarView.h"
#import "XBLevelOneCell.h"
#import "XBMoreActivitySort.h"
#import "XBMoreActivityName.h"
#import "XBMoreActivitySubName.h"
#import "XBMoreActivitySubNameItem.h"
#import "XBMoreActivitySubNameCell.h"

typedef NS_ENUM(NSInteger,XBFilterState) {
    XBFilterStateNone = 0,
    XBFilterStateNameClose,
    XBFilterStateNameOpen,
    XBFilterStateSortClose,
    XBFilterStateSortOpen
};
@interface XBMoreActivityNavigationBar() <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIView            *navigationView;
@property (strong, nonatomic) UIButton          *backButton;
@property (strong, nonatomic) UIButton          *nameButton;
@property (strong, nonatomic) UIButton          *sortButton;
@property (strong, nonatomic) UIImageView       *nameImageView;
@property (strong, nonatomic) UIView            *separatorView;
@property (strong, nonatomic) UIView            *maskView;
@property (strong, nonatomic) UITableView       *filterTableView;
@property (strong, nonatomic) UIColor           *sortDefaultColor;
@property (strong, nonatomic) UIColor           *sortSelectedColor;
@property (strong, nonatomic) NSIndexPath       *sortSelectedIndexPath;
@property (assign, nonatomic) XBFilterState     state;
@property (strong, nonatomic) XBLevelOne        *allLevelOne;
@property (strong, nonatomic) NSArray<XBMoreActivitySort *> *sortDatas;

//目标控制器 用来pop
@property (strong, nonatomic) UIViewController  *targetViewController;

@end
static NSString *const levelOneReuseIdentifier = @"XBLevelOneCell";
static NSString *const subNameReuseIdentifier  = @"XBMoreActivitySubNameCell";
@implementation XBMoreActivityNavigationBar

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController
{
    if (self = [super init]) {
        _targetViewController = targetViewController;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)targetViewController
{
    if (self = [super initWithFrame:frame]) {
        _targetViewController = targetViewController;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    //初始化
    self.sortSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.sortDefaultColor = [UIColor colorWithHexString:@"#949494"];
    
    self.sortSelectedColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    self.sortDatas = @[
                       [XBMoreActivitySort sortWithName:[XBLanguageControl localizedStringForKey:@"activity-more-sort-popular"] type:1],
                       [XBMoreActivitySort sortWithName:[XBLanguageControl localizedStringForKey:@"activity-more-sort-reviewed"] type:2],
                       [XBMoreActivitySort sortWithName:[XBLanguageControl localizedStringForKey:@"activity-more-sort-price"] type:3],
                       [XBMoreActivitySort sortWithName:[XBLanguageControl localizedStringForKey:@"activity-more-sort-top"] type:4]
                      ];

    
    UIColor *defaultColor = [UIColor whiteColor];
    
    self.backgroundColor  = defaultColor;
    
    self.maskView = [UIView new];
    self.maskView.alpha = 0.f;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeListView)]];
    [self.targetViewController.view addSubview:self.maskView];
    
    self.filterTableView = [UITableView new];
    self.filterTableView.alpha = 0.f;
    self.filterTableView.scrollEnabled = NO;
    self.filterTableView.backgroundColor = defaultColor;
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
    self.filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.filterTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBLevelOneCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:levelOneReuseIdentifier];
    [self.filterTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBMoreActivitySubNameCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:subNameReuseIdentifier];
    [self.targetViewController.view addSubview:self.filterTableView];
    
    self.navigationView = [UIView new];
    self.navigationView.backgroundColor = defaultColor;
    [self addSubview:self.navigationView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.backButton];
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nameButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.nameButton setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [self.nameButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-more-all"] forState:UIControlStateNormal];
    [self.nameButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.nameButton];
    
    self.sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sortButton setImage:[UIImage imageNamed:@"tool_sort"] forState:UIControlStateNormal];
    [self.sortButton addTarget:self action:@selector(sortAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.sortButton];
    
    self.nameImageView = [UIImageView new];
    self.nameImageView.image = [UIImage imageNamed:@"tool_more"];
    [self.navigationView addSubview:self.nameImageView];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.navigationView addSubview:self.separatorView];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.navigationView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.nameButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationView).offset(10.f);
        make.centerX.equalTo(self.navigationView);
    }];
    
    [self.nameImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameButton);
        make.left.equalTo(self.nameButton.right).offset(4);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameButton);
        make.left.equalTo(self.navigationView).offset(10);
    }];
    
    [self.sortButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameButton);
        make.right.equalTo(self.navigationView).offset(-15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.filterTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.targetViewController.view);
        make.right.equalTo(self.targetViewController.view);
        make.bottom.equalTo(self.separatorView);
        make.height.mas_greaterThanOrEqualTo(kNavigationBarFooterHeight);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView);
        make.bottom.equalTo(self.navigationView);
        make.right.equalTo(self.navigationView);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.targetViewController.view);
        make.right.equalTo(self.targetViewController.view);
        make.bottom.equalTo(self.targetViewController.view);
        make.top.equalTo(self.filterTableView.bottom);
    }];
    
}

- (void)reloadData
{
    [self.filterTableView reloadData];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.state == XBFilterStateNone || self.state == XBFilterStateNameClose || self.state == XBFilterStateSortClose) {
    
        return 0;
    
    } else if (self.state == XBFilterStateNameOpen) {
    
        return self.name.items.count;
    
    }
    return self.sortDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.state == XBFilterStateNameOpen) {
        
        XBLevelOneCell *cell = [tableView dequeueReusableCellWithIdentifier:levelOneReuseIdentifier forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        XBLevelOne *levelOne = self.name.items[indexPath.row];
        
        cell.titleLabel.text = levelOne.name;
        
        NSString *imageName  = [NSString stringWithFormat:@"levelOne%@",levelOne.type];
        
        cell.iconImageView.image = [UIImage imageNamed:imageName];
        
        return cell;

    }
    
    XBMoreActivitySubNameCell *cell = [tableView dequeueReusableCellWithIdentifier:subNameReuseIdentifier forIndexPath:indexPath];
    
    cell.sort = self.sortDatas[indexPath.row];
    
    cell.titleLabel.textColor = [self.sortSelectedIndexPath isEqual:indexPath] ? self.sortSelectedColor : self.sortDefaultColor;
    
    cell.checkMarkButton.hidden = ![self.sortSelectedIndexPath isEqual:indexPath];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.state == XBFilterStateNameOpen ? kLevelOneRowHeight : kSortRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.state == XBFilterStateNameOpen ? kNavigationBarFooterHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kNavigationBarFooterHeight)];
    
    footerView.userInteractionEnabled = YES;
    
    [footerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerTapGesture)]];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footerView.frame), 0.5)];
    
    separatorView.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    
    [footerView addSubview:separatorView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, CGRectGetWidth(footerView.frame), CGRectGetHeight(footerView.frame) - 0.5)];
    
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-more-footerall"];
    
    titleLabel.textColor = [UIColor colorWithHexString:@"#515151"];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [footerView addSubview:titleLabel];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.state == XBFilterStateSortOpen) {
        
        //取消之前选中状态
        
        XBMoreActivitySubNameCell *selectedCell = [tableView cellForRowAtIndexPath:self.sortSelectedIndexPath];
        
        selectedCell.titleLabel.textColor = self.sortDefaultColor;
        
        selectedCell.checkMarkButton.hidden = YES;
        
        self.sortSelectedIndexPath = indexPath;
        
        XBMoreActivitySubNameCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.titleLabel.textColor = self.sortSelectedColor;
        
        cell.checkMarkButton.hidden = NO;
        
        //延迟设置 以便能看到选中的行的状态
        [UIView animateWithDuration:0.35 animations:^{
            
        } completion:^(BOOL finished) {
            
            if ([self.delegate respondsToSelector:@selector(navigationBar:didSelectedWithMoreActivitySort:)]) {
                [self.delegate navigationBar:self didSelectedWithMoreActivitySort:self.sortDatas[indexPath.row]];
            }
            
            [self closeListView];
        }];
        
    } else if (self.state == XBFilterStateNameOpen) {
        
        XBLevelOne *levelOne = self.name.items[indexPath.row];
        
        [self.nameButton setTitle:levelOne.name forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(navigationBar:didSelectedWithLevelOne:)]) {
            [self.delegate navigationBar:self didSelectedWithLevelOne:levelOne];
        }
        
        [self closeListView];
    }
    
}

- (void)popAction
{
    [self.targetViewController.navigationController popViewControllerAnimated:YES];
}

- (void)nameAction
{
    if (self.state == XBFilterStateSortOpen) {
        
        CGRect frame = self.filterTableView.frame;
        
        frame.origin.y -= CGRectGetHeight(self.filterTableView.frame);
        
        self.filterTableView.frame = frame;
        
        self.filterTableView.alpha = 0.;
        
        self.state = XBFilterStateNameClose;
        
    } else if (self.state == XBFilterStateNone || self.state == XBFilterStateSortClose) {
        
        self.state = XBFilterStateNameClose;
        
    }
    
    [self showNameAnimation];

}

- (void)sortAction
{
    if (self.state == XBFilterStateNameOpen) {
        
        CGRect frame = self.filterTableView.frame;
        
        frame.origin.y -= CGRectGetHeight(self.filterTableView.frame);
        
        self.filterTableView.frame = frame;
        
        self.filterTableView.alpha = 0.;
        
        self.state = XBFilterStateSortClose;
        
        [self nameImageViewAnimationIsOpen:NO];
        
    } else if (self.state == XBFilterStateNone || self.state == XBFilterStateNameClose) {
        
        self.state = XBFilterStateSortClose;
        
    }
    
    [self showSortAnimation];
}

- (void)showSortAnimation
{
    if (self.state == XBFilterStateSortClose) {
        
        [self.targetViewController.view bringSubviewToFront:self.maskView];
        
        [self.targetViewController.view bringSubviewToFront:self.filterTableView];
        
        [self.targetViewController.view bringSubviewToFront:self];
        
        self.state = XBFilterStateSortOpen;
        
        [self.filterTableView reloadData];
        
        self.filterTableView.alpha = 1.f;
        
        [self.filterTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSortRowHeight * self.sortDatas.count);
        }];
        
        [self.filterTableView layoutIfNeeded];
        
        [self openFilterTableView];
        
    } else {
        
        [self closeFilterTableViewWithCompleteState:XBFilterStateSortClose];
    }
}



- (void)showNameAnimation
{
    if (self.state == XBFilterStateNameClose) {
        
        [self.targetViewController.view bringSubviewToFront:self.maskView];
        
        [self.targetViewController.view bringSubviewToFront:self.filterTableView];
        
        [self.targetViewController.view bringSubviewToFront:self];
        
        self.state = XBFilterStateNameOpen;
        
        [self.filterTableView reloadData];
        
        self.filterTableView.alpha = 1.f;
        
        [self.filterTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLevelOneRowHeight * self.name.items.count + kNavigationBarFooterHeight);
        }];
        
        [self.filterTableView layoutIfNeeded];
        
        [self openFilterTableView];
    
        [self nameImageViewAnimationIsOpen:YES];
        
    } else {
        
        [self closeFilterTableViewWithCompleteState:XBFilterStateNameClose];
        
        [self nameImageViewAnimationIsOpen:NO];
        
    }
}

- (void)openFilterTableView
{
    [UIView animateWithDuration:kOpenDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CGRect frame = self.filterTableView.frame;
        
        frame.origin.y = kNavigationBarHeight;
        
        self.filterTableView.frame = frame;
        
        self.maskView.alpha = 1.f;
        
    } completion:^(BOOL finished) {
        
        //TODO 修复第一次点击无法弹出tableView
        if (self.filterTableView.xb_y != kNavigationBarHeight) {
            
            [UIView animateWithDuration:kOpenDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                CGRect frame = self.filterTableView.frame;
                
                frame.origin.y = kNavigationBarHeight;
                
                self.filterTableView.frame = frame;
                
                self.maskView.alpha = 1.f;
                
            } completion:nil];
        }
    }];
    
}

- (void)closeFilterTableViewWithCompleteState:(XBFilterState)state
{
    [UIView animateWithDuration:kCloseDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.filterTableView.alpha = 0.f;
        
        self.maskView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        self.state = state;
        
        CGRect frame = self.filterTableView.frame;
        
        frame.origin.y = kNavigationBarHeight - CGRectGetHeight(self.filterTableView.frame);
        
        self.filterTableView.frame = frame;
        
    }];
}

- (void)nameImageViewAnimationIsOpen:(BOOL)isOpen
{
    CABasicAnimation *subNameAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    subNameAnimation.fromValue = isOpen ? @(0) : @(M_PI);
    subNameAnimation.toValue   = isOpen ? @(M_PI) : @(2 * M_PI);
    subNameAnimation.duration  = isOpen ? kOpenDuration : kCloseDuration;
    subNameAnimation.fillMode  = kCAFillModeForwards;
    subNameAnimation.removedOnCompletion = NO;
    [self.nameImageView.layer addAnimation:subNameAnimation forKey:@"subNameAnimation"];
}

#pragma mark -- methods
- (void)setHideTitle:(BOOL)hideTitle
{
    _hideTitle = hideTitle;
    
    self.nameButton.hidden = hideTitle;
    
    self.nameImageView.hidden = hideTitle;
}

- (void)setSortEnable:(BOOL)sortEnable
{
    _sortEnable = sortEnable;
    
    self.sortButton.enabled = sortEnable;
}

- (void)closeListView
{
    if (self.state == XBFilterStateNameOpen) {
        [self nameAction];
    } else if (self.state == XBFilterStateSortOpen) {
        [self sortAction];
    }
}

- (void)removeAllSubviews
{
    [self.filterTableView removeFromSuperview];
    
    [self.navigationView removeFromSuperview];
}

- (void)footerTapGesture
{
    [self.nameButton setTitle:self.allLevelOne.name forState:UIControlStateNormal];
    
    [self showNameAnimation];
    
    if ([self.delegate respondsToSelector:@selector(navigationBar:didSelectedWithLevelOne:)]) {
        [self.delegate navigationBar:self didSelectedWithLevelOne:self.allLevelOne];
    }
}

- (XBLevelOne *)allLevelOne
{
    if (!_allLevelOne) {
        _allLevelOne = [[XBLevelOne alloc] init];
        _allLevelOne.type = @"-1";
        _allLevelOne.name = [XBLanguageControl localizedStringForKey:@"activity-more-nodata"];
    }
    return _allLevelOne;
}


@end
