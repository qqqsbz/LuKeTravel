//
//  XBShareView.m
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f

#import "XBShareView.h"
#import "WXApi.h"
#import "XBShare.h"
#import "XBShareCell.h"
#import "XBShareActivity.h"
#import "UMSocialSnsPlatformManager.h"
@interface XBShareView() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) UIView   *dismissView;
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UICollectionView    *collectionView;
@property (strong, nonatomic) UIVisualEffectView  *effectView;

@property (strong, nonatomic) NSMutableArray   *datas;
@property (strong, nonatomic) XBShareActivity  *shareActivity;
@property (strong, nonatomic) UIViewController *targetViewController;
@end

static NSString *const reuseIdentifier = @"XBShareCell";
@implementation XBShareView
- (instancetype)initWithShareActivity:(XBShareActivity *)shareActivity targetViewController:(UIViewController *)targetViewController
{
    if (self = [super init]) {
        _shareActivity = shareActivity;
        _targetViewController = targetViewController;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame shareActivity:(XBShareActivity *)shareActivity targetViewController:(UIViewController *)targetViewController
{
    if (self = [super initWithFrame:frame]) {
        _shareActivity = shareActivity;
        _targetViewController = targetViewController;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.alpha = 0.f;
    
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self addSubview:self.effectView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = NSLocalizedString(@"share-activity-title", @"share-activity-title");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = [UIFont systemFontOfSize:17.5f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#717171"];
    [self addSubview:self.titleLabel];
    
    self.dismissView = [UIView new];
    self.dismissView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.dismissView];
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dismissButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissView addSubview:self.dismissButton];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = -10;
    flowLayout.minimumLineSpacing = -5;
    flowLayout.itemSize = CGSizeMake(80, 100);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBShareCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(80.f);
    }];
    
    [self.dismissView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.dismissView);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 3);
        make.right.equalTo(self).offset(-kSpace * 3);
        make.height.mas_greaterThanOrEqualTo(200.f);
        make.centerY.equalTo(self).offset(-kSpace * 2.5);
    }];
}

- (void)reloadData
{
    
    if (self.datas.count <= 0) {
        //手机是否安装了微信  如果不添加该判断 当手机没有安装微信 上架到app store 会不通过审核
        if ([WXApi isWXAppInstalled]) {
            
            [self.datas addObject:[XBShare shareWithName:NSLocalizedString(@"share-wechat-session", @"share-wechat-session") icon:[UIImage imageNamed:@"share_wechat"] plantform:UMShareToWechatSession]];
            
            [self.datas addObject:[XBShare shareWithName:NSLocalizedString(@"share-wechat-timeline", @"share-wechat-timeline") icon:[UIImage imageNamed:@"share_moments"] plantform:UMShareToWechatTimeline]];
            
        }
        
        [self.datas addObject:[XBShare shareWithName:NSLocalizedString(@"share-sina", @"share-sina") icon:[UIImage imageNamed:@"share_sina"] plantform:UMShareToSina]];
        
        [self.datas addObject:[XBShare shareWithName:NSLocalizedString(@"share-email", @"share-email") icon:[UIImage imageNamed:@"share_email"] plantform:UMShareToEmail]];
        
        [self.datas addObject:[XBShare shareWithName:NSLocalizedString(@"share-message", @"share-message") icon:[UIImage imageNamed:@"share_message"] plantform:UMShareToSms]];
        
        [self.datas addObject:[XBShare shareWithName:NSLocalizedString(@"share-twitter", @"share-twitter") icon:[UIImage imageNamed:@"share_twitter"] plantform:UMShareToTwitter]];
    }

    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.share = self.datas[indexPath.row];
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBShare *share = self.datas[indexPath.row];
    
    [self shareToPlatform:share.plantform];
}

- (void)shareToPlatform:(NSString *)platform
{
    UMSocialExtConfig *extConfig = [UMSocialData defaultData].extConfig;
    extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    extConfig.wechatTimelineData.url = self.shareActivity.url;
    extConfig.qzoneData.url = self.shareActivity.url;
    extConfig.wechatSessionData.url = self.shareActivity.url;
    
    UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareActivity.image]]];
    [[UMSocialControllerService defaultControllerService] setShareText:self.shareActivity.title shareImage:shareImage socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platform].snsClickHandler(self.targetViewController, [UMSocialControllerService defaultControllerService], YES);
    
}

- (void)toggle
{
    if (self.alpha == 0) {
        
        [self reloadData];
        
        [self.superview bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        
        [self.superview sendSubviewToBack:self];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}


#pragma mark -- lazy loading
- (NSMutableArray *)datas
{
    if (!_datas) {
        
        _datas = [NSMutableArray array];
    
    }
    return _datas;
}


@end
