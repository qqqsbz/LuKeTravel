//
//  XBBookOrderViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBookOrderViewController.h"
#import "XBArrangement.h"
#import "XBOrderBookView.h"
#import "XBOrderTicketViewController.h"
@interface XBBookOrderViewController () <XBOrderBookViewDelegate>
/** 订单 */
@property (strong, nonatomic) XBOrderBookView *orderBookView;
@end

@implementation XBBookOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
}

- (void)buildView
{
    self.title = [XBLanguageControl localizedStringForKey:@"activity-order-book-title"];
    
    self.orderBookView = [XBOrderBookView new];
    self.orderBookView.delegate = self;
    [self.view addSubview:self.orderBookView];
}

- (void)setArrangement:(XBArrangement *)arrangement
{
    _arrangement = arrangement;
    
    [self reloadOrderBook];
}

/** 加载订单详细资料 */
- (void)reloadOrderBook
{
    [self showLoadinng];
    
    [[XBHttpClient shareInstance] getOrderBookWithArrangementId:[self.arrangement.modelId integerValue] success:^(XBOrderBook *orderBook) {
        
        self.orderBookView.bookDate = self.arrangement.startTime;
        
        self.orderBookView.orderBook = orderBook;
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
    }];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.orderBookView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(44);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- XBOrderBookViewDelegate
- (void)orderBookView:(XBOrderBookView *)orderBookView exceedMax:(NSInteger)max
{
    [self showToast:[NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-max"],max]];
}

- (void)orderBookView:(XBOrderBookView *)orderBookView bookOrderWithParams:(NSArray<NSNumber *> *)param
{
    
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] bookOrderWithArrangementId:[self.arrangement.modelId integerValue] params:param success:^(XBBook *book) {
        
        [self hideLoading];

        XBOrderTicketViewController *orderTicketVC = [[XBOrderTicketViewController alloc] init];
        
        orderTicketVC.book = book;
        
        self.navigationController.delegate = orderTicketVC;
        
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        
        [self.navigationController pushViewController:orderTicketVC animated:YES];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *errorMsg = @"";
        
        if (error.code == kBookErrorCode) {
            
            errorMsg = [error.userInfo valueForKey:kErrorMessage];
        
        } else {
            
            errorMsg = [XBLanguageControl localizedStringForKey:@"error-no-network-signal"];
        }
        
        [self showAlertWithTitle:errorMsg];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
