//
//  XBStretchableCityHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kTopSapce       45.f
#define kSpace          10.f
#define kRowHeight      48.f
#define kHeaderHeight   70.f

#import "XBStretchableCityHeaderView.h"
#import "XBLevelOne.h"
#import "XBLevelOneCell.h"
@interface XBStretchableCityHeaderView() <UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) CGRect   initialFrame;
@property (assign, nonatomic) CGFloat  defaultViewHeight;
@property (strong, nonatomic) UIView   *contentView;
@end
static NSString *const reuseIdentifier = @"XBLevelOneCell";
@implementation XBStretchableCityHeaderView
- (void)stretchHeaderForTableView:(UITableView *)tableView withView:(UIView *)view
{
    _tableView = tableView;
    _coverView = view;
    
    _initialFrame       = _coverView.frame;
    _defaultViewHeight  = _initialFrame.size.height;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 470)];
    
    self.temperatureImageView = [UIImageView new];
    self.temperatureImageView.alpha = 0;
    
    self.temperatureLabel = [UILabel new];
    self.temperatureLabel.alpha = 0.f;
    self.temperatureLabel.font = [UIFont systemFontOfSize:16.5f];
    self.temperatureLabel.textColor = [UIColor colorWithWhite:1 alpha:0.85f];

    self.levelOneTableView = [UITableView new];
    self.levelOneTableView.dataSource = self;
    self.levelOneTableView.delegate   = self;
    self.levelOneTableView.layer.masksToBounds = YES;
    self.levelOneTableView.layer.cornerRadius  = 8.f;
    self.levelOneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.levelOneTableView.backgroundColor = [UIColor whiteColor];
    [self.levelOneTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBLevelOneCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.contentView addSubview:self.levelOneTableView];
    
    
    [_tableView addSubview:_coverView];

    [self.contentView addSubview:self.temperatureLabel];
    
    [self.contentView addSubview:self.temperatureImageView];
    
    _tableView.tableHeaderView = self.contentView;
    
    
    [self addConstraint];
    
}

- (void)setLevelOnes:(NSArray<XBLevelOne *> *)levelOnes
{
    _levelOnes = levelOnes;
    [self.levelOneTableView reloadData];
    
//    if (_levelOnes.count < 5) {
//        
//        NSInteger distance =  5 - levelOnes.count;
//        
//        CGFloat tableHeight = CGRectGetHeight(self.levelOneTableView.frame) - distance * kRowHeight;
//        [self.levelOneTableView updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(tableHeight);
//        }];
//        
//        self.contentView.xb_height -= distance * kRowHeight;
//    }
}

- (void)addConstraint
{
    [self.levelOneTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace);
        make.right.equalTo(self.contentView).offset(-kSpace);
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(CGRectGetMaxY(self.coverView.frame) - kTopSapce);
    }];
    
    [self.temperatureImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.levelOneTableView.left).offset(kSpace);
        make.bottom.equalTo(self.levelOneTableView.top).offset(-kSpace * 1.1);
    }];
    
    [self.temperatureLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.temperatureImageView);
        make.left.equalTo(self.temperatureImageView.right).offset(kSpace * 0.7);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f     = _coverView.frame;
    f.size.width = _tableView.frame.size.width;
    _coverView.frame  = f;
    
    if(scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        _initialFrame.origin.y = - offsetY * 1;
        
        _initialFrame.size.height = _defaultViewHeight + offsetY;
        
        _coverView.frame = _initialFrame;
    }
    
}


- (void)resizeView
{
    _initialFrame.size.width = _tableView.frame.size.width;
    _coverView.frame = _initialFrame;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _levelOnes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBLevelOneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    XBLevelOne *levelOne = self.levelOnes[indexPath.row];
    
    cell.titleLabel.text = levelOne.name;
    
    NSString *imageName = [NSString stringWithFormat:@"levelOne%@",levelOne.type];
    
    cell.iconImageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kHeaderHeight)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(view.frame) - 20, kHeaderHeight)];
    label.text = self.title;
    label.font = [UIFont systemFontOfSize:30.f];
    [view addSubview:label];
    return view;
}


- (void)startLevelOneAnimationWithComplete:(dispatch_block_t)block
{
    [self.levelOneTableView layoutIfNeeded];
    
    CGRect levelOneRect = self.levelOneTableView.frame;
    
    self.levelOneTableView.xb_y += kTopSapce;
    
    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.levelOneTableView.frame = levelOneRect;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            if (block) {
                block();
            }
        }
        
    }];
}

- (void)startWeatherAnimationWithComplete:(dispatch_block_t)block
{
    
    [self.temperatureImageView layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.temperatureLabel.alpha = 1;
        
        self.temperatureImageView.alpha = 1;
        
        self.temperatureImageView.xb_y += kTopSapce;
        
        self.temperatureLabel.xb_y += kTopSapce;
        
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            if (block) {
                block();
            }
        }
        
    }];
    
}

@end
