//
//  XBActivityDetailViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kTitleTag   10000
#define kContentTag 20000
#define kSpace 10

#import "XBActivityDetailViewController.h"
#import "XBParserContent.h"
#import "XBActivityItemView.h"
#import "XBParserContentItem.h"
@interface XBActivityDetailViewController () <XBActivityItemViewDelegate>
@property (strong, nonatomic) UIScrollView    *scrollView;
@property (strong, nonatomic) UIView          *contentView;
@property (strong, nonatomic) NSMutableArray  *subViews;
@property (strong, nonatomic) NSArray<XBParserContent *>  *parserContents;

@property (strong, nonatomic) NSString  *navigationTitle;
@end

@implementation XBActivityDetailViewController

- (instancetype)initWithParserContents:(NSArray<XBParserContent *> *)parserContents navigationTitle:(NSString *)title
{
    if (self = [super init]) {
        _parserContents = parserContents;
        _navigationTitle = title;
        [self buildView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationtTitleLabel.text = _navigationTitle;
    
    self.navigationRightButton.hidden = YES;
}

- (void)buildView
{
    self.subViews = [NSMutableArray array];
    
    self.scrollView = [UIScrollView new];
    
    [self.view addSubview:self.scrollView];
    
    self.contentView = [UIView new];
    
    [self.scrollView addSubview:self.contentView];
    //创建标题
    for (XBParserContent *parserContent in self.parserContents) {
        
        if (parserContent.title.length > 0) {
            
            UILabel *titleLabel =  [UILabel new];
            
            titleLabel.tag = kTitleTag;
            
            titleLabel.text = parserContent.title;
            
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
            
            titleLabel.textColor = [UIColor colorWithHexString:kDefaultColorHex];
            
            [self.contentView addSubview:titleLabel];
            
            [self.subViews addObject:titleLabel];
        }
        
        //创建内容
        for (XBParserContentItem *contentItem in parserContent.items) {
            
            XBActivityItemView *contentItemView = [[XBActivityItemView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            
            contentItemView.tag = kContentTag;
            
            contentItemView.parserContentItem = contentItem;
            
            contentItemView.delegate = self;
           
            [self.contentView addSubview:contentItemView];
            
            [self.subViews addObject:contentItemView];
        }
        
    }
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64.f);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
    }];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIView *firstView = [self.subViews firstObject];
    
    UIView *lastView  = [self.subViews lastObject];
    
    [firstView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([self convertSpace:firstView]);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-[self convertSpace:firstView]);
    }];
    
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-kSpace * 0.5);
    }];
    
    for (NSInteger i = 1; i < self.subViews.count; i ++) {
        
        UIView *previousView = self.subViews[i - 1];
        
        UIView *currentView = self.subViews[i];
        
        [currentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([self convertSpace:firstView]);
            make.top.equalTo(previousView.bottom).offset(kSpace * 1.4);
            make.right.equalTo(self.contentView).offset(-[self convertSpace:firstView]);
            make.width.mas_greaterThanOrEqualTo(50);
        }];
        
    }

}

- (CGFloat)convertSpace:(UIView *)view
{
    return view.tag == kTitleTag ? kSpace : kSpace * 1.8f;
}

#pragma mark -- XBActivityItemViewDelegate
- (void)activityItemView:(XBActivityItemView *)activityItemView didSelectLinkWithURL:(NSURL *)url
{
    DDLogDebug(@"url:%@",url);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
