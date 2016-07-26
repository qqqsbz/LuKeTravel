//
//  XBActivityReviewView.m
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivityReviewMaskView.h"
#import "XBReview.h"
#import "XBComment.h"
#import "NSString+Util.h"
#import "XBActivityReviewCell.h"
#import <MJRefresh/MJRefresh.h>
@interface XBActivityReviewMaskView() <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UILabel              *titleLabel;
@property (strong, nonatomic) UITableView          *tableView;
@property (strong, nonatomic) UIVisualEffectView   *effectView;
@property (strong, nonatomic) UIActivityIndicatorView  *indicatorView;

@property (strong, nonatomic) XBActivityReviewCell  *prototypeCell;
@property (assign, nonatomic) NSInteger  page;
@property (strong, nonatomic) NSArray    *datas;
@end

static NSString *const reuseIdentifier = @"XBActivityReviewCell";
@implementation XBActivityReviewMaskView

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
    self.page = 1;
    
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self addSubview:self.effectView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = NSLocalizedString(@"activity-detail-reviewcount", @"activity-detail-reviewcount");
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBActivityReviewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self addSubview:self.tableView];
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.indicatorView];
    
    [self addTableViewFooter];
}

- (void)layoutSubviews
{
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_offset(44.f);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLabel.bottom);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setActivityId:(NSInteger)activityId
{
    _activityId = activityId;

    [self reloadData];
}

- (void)reloadData
{
    if (self.datas.count > 0) {
        self.indicatorView.hidden = YES;
    } else {
        [self.indicatorView startAnimating];
    }
    
    [[XBHttpClient shareInstance] getReviewsWithActivitiesId:self.activityId page:self.page success:^(XBReview *review) {
        
        if (self.datas.count <= 0) {
        
            self.datas = review.reviews;
        
        } else {
            
            self.datas = [self.datas arrayByAddingObjectsFromArray:review.reviews];
            
        }
        
        [self.tableView reloadData];
        
        self.indicatorView.hidden = YES;
        
        self.page ++;
        
        self.tableView.mj_footer.hidden = NO;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)addTableViewFooter
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self reloadData];
        
    }];
    
    footer.hidden = YES;
    
    footer.refreshingTitleHidden = YES;
    
    self.tableView.mj_footer = footer;
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBActivityReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.comment = self.datas[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 125;
    XBComment *comment = self.datas[indexPath.row];
    self.prototypeCell.contentLabel.text = comment.content;
    CGFloat height = CGRectGetHeight(self.prototypeCell.contentLabel.frame);
    CGSize size = [comment.content sizeWithFont:self.prototypeCell.contentLabel.font maxSize:CGSizeMake(CGRectGetWidth(self.prototypeCell.contentLabel.frame), NSIntegerMax)];
    result += size.height > height ? size.height + height * 1.5 : 0;
    return result;
}

@end
