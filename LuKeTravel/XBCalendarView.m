//
//  XBCalendarView.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kItemWidth   52
#define kMontnCount  4
#define kHeaderWidth 30
#define kAheadDays   3
#import "XBCalendarView.h"
#import "XBCalendarCell.h"
#import "XBDate.h"
#import "XBPlainFlowLayout.h"
@interface XBCalendarView() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UIView            *separatorView;
@property (strong, nonatomic) NSMutableArray    *datas;
@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) XBPlainFlowLayout *flowLayout;
@property (strong, nonatomic) NSIndexPath       *selectedIndexPath;
@end

static NSString *const reuseIdentifier = @"XBCalendarCell";
static NSString *const headerReuseIdentifier = @"XBHeader";
@implementation XBCalendarView
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
    self.flowLayout = [[XBPlainFlowLayout alloc] init];
    self.flowLayout.naviHeight = kHeaderWidth;
    self.flowLayout.minimumInteritemSpacing = 0.f;
    self.flowLayout.minimumLineSpacing = 0.f;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBCalendarCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
    [self addSubview:self.collectionView];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#D1D2D3"];
    [self addSubview:self.separatorView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.collectionView layoutIfNeeded];
    
    self.flowLayout.itemSize = CGSizeMake(kItemWidth, CGRectGetHeight(self.collectionView.frame));

}

- (void)loadData
{
    
    self.datas = [NSMutableArray arrayWithCapacity:kMontnCount];
    
    NSDate *date = [NSDate date];
    
    NSString *weekString = @"";
    
    NSString *dateString = @"";
    
    NSDate   *forMatterDate;
    
    NSDateComponents *toDayComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    toDayComponents.day = 4;
    
    //默认获取五个月份
    for (NSInteger i = 0; i <= kMontnCount;  i ++) {
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        dateComponents.month = + i;
        
        NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
        
        NSDateComponents *cmp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:newDate];
        
        NSInteger dateCount = [self totaldaysInThisMonth:newDate];
        
        NSMutableArray *days = [NSMutableArray arrayWithCapacity:dateCount];
        
        //计算日期
        for (NSInteger j = 1; j <= dateCount; j ++) {
            
            if (i == kMontnCount) {
                
                if (toDayComponents.day - kAheadDays > 0) {
                    if (j > (toDayComponents.day - kAheadDays)) {
                        break;
                    }
                } else {
                    
                    if (j > dateCount + (toDayComponents.day - kAheadDays)) {
                        break;
                    }
                    
                }
            }
            
            if (toDayComponents.month != cmp.month || cmp.day <= j) {
               
                cmp.day = j;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                dateString = [NSString stringWithFormat:@"%@-%@-%@",[NSIntegerFormatter formatToNSString:cmp.year],[NSIntegerFormatter formatToNSString:cmp.month],[NSIntegerFormatter formatToNSString:cmp.day]];
                
                forMatterDate = [dateFormatter dateFromString:dateString];
                
                weekString = cmp.month == toDayComponents.month && cmp.day == toDayComponents.day ? @"今天" : [self weekOfDay:forMatterDate];
                
                [days addObject:[XBDate dateWithDate:dateString week:weekString day:[NSIntegerFormatter formatToNSString:cmp.day fix:YES] month:[NSString stringWithFormat:@"%@月",[NSIntegerFormatter formatToNSString:cmp.month]]]];
            }
        }
        
        [self.datas addObject:days];
    }
    [self.collectionView reloadData];
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *days = self.datas[section];
    return days.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dates = self.datas[indexPath.section];
    XBDate *date   = dates[indexPath.row];
    XBCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.weekLabel.text = date.week;
    cell.dayLabel.text  = date.day;
    cell.itemSelected   = [indexPath isEqual:self.selectedIndexPath];
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBCalendarCell *cell = (XBCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemSelected = YES;
    self.selectedIndexPath = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBCalendarCell *cell = (XBCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.itemSelected = NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){kHeaderWidth,CGRectGetHeight(collectionView.frame)};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){0,0};
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        
        //清空子类
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        NSArray *dates = self.datas[indexPath.section];
        
        XBDate *date   = dates[indexPath.row];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-kHeaderWidth * 0.5, CGRectGetHeight(self.collectionView.frame) - kHeaderWidth * 1.5, CGRectGetHeight(self.collectionView.frame), kHeaderWidth)];
        
        titleLabel.text = date.month;
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.textColor = [UIColor colorWithHexString:@"#4B4B4B"];
        
        titleLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        [headerView addSubview:titleLabel];
        
        return headerView;
    }
    
    return nil;
}


#pragma mark -- NSDate 
- (NSDate *)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = + 1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSString *)weekOfDay:(NSDate *)date
{
    
    NSString *weekDayStr = @"";
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    
    switch ([comps weekday]) {
        case 1:
            weekDayStr = @"周日";
            break;
        case 2:
            weekDayStr = @"周一";
            break;
        case 3:
            weekDayStr = @"周二";
            break;
        case 4:
            weekDayStr = @"周三";
            break;
        case 5:
            weekDayStr = @"周四";
            break;
        case 6:
            weekDayStr = @"周五";
            break;
        case 7:
            weekDayStr = @"周六";
            break;
    }
    
    return weekDayStr;
}

@end
