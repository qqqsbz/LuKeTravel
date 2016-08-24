//
//  XBOrderBookView.m
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderBookView.h"
#import "XBOrderBook.h"
#import "XBOrderNextView.h"
#import "XBOrderBookCell.h"
#import "XBOrderBookPrice.h"
#import "XBBookOrderMoneyCell.h"
#import "XBBookOrderHeaderView.h"
@interface XBOrderBookView() <UITableViewDelegate,UITableViewDataSource,XBOrderBookCellDelegate>
/** 数据列表 */
@property (strong, nonatomic) UITableView *tableView;
/** headerView */
@property (strong, nonatomic) XBBookOrderHeaderView *headerView;
/** 金额 */
@property (strong, nonatomic) XBBookOrderMoneyCell *moneyCell;
/** 总金额 */
@property (assign, nonatomic) NSInteger  total;
/** 节约 */
@property (assign, nonatomic) NSInteger  save;
/** 参数 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *params;
@end
static NSString *const reuseIdentifier = @"XBOrderBookCell";
static NSString *const moneyReuseIdentifier = @"XBBookOrderMoneyCell";
@implementation XBOrderBookView

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

- (void)setOrderBook:(XBOrderBook *)orderBook
{
    _orderBook = orderBook;
    
    [self.tableView reloadData];
    
    self.headerView.detailLabel.text = self.bookDate;
    
    //初始化参数
    
    self.params = [NSMutableArray array];
    
    for (NSInteger i = 0; i < orderBook.prices.count; i ++) {
        
        [self.params addObject:[NSNumber numberWithInteger:0]];
    }
    
}

- (void)initialization
{
    self.tableView = [UITableView new];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderBookCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBBookOrderMoneyCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:moneyReuseIdentifier];
    
    self.moneyCell = [self.tableView dequeueReusableCellWithIdentifier:moneyReuseIdentifier];
    
    [self addSubview:self.tableView];
    
    self.moneyCell.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-total"];
    
    self.moneyCell.moneyLabel.text = [NSString stringWithFormat:@"%@ 0",[XBUserDefaultsUtil currentCurrencySymbol]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.headerView = [[XBBookOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.xb_width, 45.f)];
    
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.headerView;
    
    XBOrderNextView *nextView = [[XBOrderNextView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.xb_width, 85) nextBlock:^{
        
        if ([self.delegate respondsToSelector:@selector(orderBookView:bookOrderWithParams:)]) {
            
            [self.delegate orderBookView:self bookOrderWithParams:self.params];
        }
        
    }];
    nextView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = nextView;
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderBook.prices.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.orderBook.prices.count) {
        
        XBOrderBookCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.orderBookPrice = self.orderBook.prices[indexPath.row];
        
        cell.delegate = self;
        
        return cell;
    }
    
    return self.moneyCell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.orderBook.prices.count ? 100 : 80;
}

#pragma mark -- XBOrderBookCellDelegate
- (void)orderBookCell:(XBOrderBookCell *)orderBookCell didSelectCountWithOrderBookPrice:(XBOrderBookPrice *)orderBookPrice isPlus:(BOOL)isPlus
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:orderBookCell];
    
    NSInteger count = [self.params[indexPath.row] integerValue];
    
    if (isPlus) {
        
        ++ count;
        
        self.total += orderBookPrice.price;
        
        self.save += orderBookPrice.marketPrice - orderBookPrice.price;
    
    } else {
        
        -- count;
        
        self.total -= orderBookPrice.price;
        
        self.save -= orderBookPrice.marketPrice - orderBookPrice.price;
        
    }
    
    [self.params replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInteger:count]];
    
    self.moneyCell.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:self.total]];
    
    NSString *saveString = [XBLanguageControl localizedStringForKey:@"activity-order-save"];
    
    saveString = [saveString stringByAppendingString:[NSString stringWithFormat:@" %@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:self.save]]];
    
    self.moneyCell.saveLabel.text = saveString;
    
    self.moneyCell.saveLabel.hidden = self.save <= 0;
    
}

- (void)orderBookCell:(XBOrderBookCell *)orderBookCell exceedMax:(NSInteger)count
{
    if ([self.delegate respondsToSelector:@selector(orderBookView:exceedMax:)]) {
        
        [self.delegate orderBookView:self exceedMax:count];
        
    }
}

@end
