//
//  XBOrderCalendarView.m
//  LuKeTravel
//
//  Created by coder on 16/8/10.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kTodayTag 0
#define kUnTodayTag 1

#import "XBOrderCalendarView.h"
#import "XBArrangement.h"
#import "UIImage+Util.h"
#import "XBPickerView.h"
#import "XBOrderNavigationBar.h"
#import "XBOrderCalendarCell.h"
@interface XBOrderCalendarView() <UICollectionViewDelegate,UICollectionViewDataSource,XBPickerViewDelegate,XBPickerViewDatasource>
/** 导航栏 */
@property (strong, nonatomic) XBOrderNavigationBar *navigationBar;
/** 滚动栏 */
@property (strong, nonatomic) UIScrollView *scrollView;
/** 滚动view 存放其他view的内容view */
@property (strong, nonatomic) UIView *scrollContentView;
/** 日期view */
@property (strong, nonatomic) UIView   *monthView;
/** 上个月 */
@property (strong, nonatomic) UIButton *lastMonthButton;
/** 当前年月 */
@property (strong, nonatomic) UILabel  *monthLabel;
/** 下个月 */
@property (strong, nonatomic) UIButton *nextMonthButton;
/** 日历 */
@property (strong, nonatomic) UICollectionView *calendarView;
/** 日历布局 */
@property (strong, nonatomic) UICollectionViewFlowLayout *calendarFlowLayout;
/** 分割线 */
@property (strong, nonatomic) UIView *separatorView;
/** 时间段View */
@property (strong, nonatomic) UIView *timeView;
/** 时间标题 */
@property (strong, nonatomic) UILabel *timeTitleLabel;
/** 时间 */
@property (strong, nonatomic) UILabel *timeDetailLabel;
/** 时间段顶部分割线 */
@property (strong, nonatomic) UIView *timeTopSeparatorView;
/** 时间段底部分割线 */
@property (strong, nonatomic) UIView *timeBottomSeparatorView;
/** 选择日期按钮 */
@property (strong, nonatomic) UIButton *orderButton;
/** 星期 */
@property (strong, nonatomic) NSArray<NSString *> *weeks;
/** 本月天数 */
@property (strong, nonatomic) NSMutableArray *allDayArray;
/** 可以下单的日期 */
@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *canOrderIndexPaths;
/** 当前日期 */
@property (strong, nonatomic) NSDate *currentDate;
/** 日历对象 */
@property (strong, nonatomic) NSCalendar *calendar;
/** 选中的那天 避免切换到另外一个月份选中其他 */
@property (strong, nonatomic) NSString *selectDay;
/** 时间段 */
@property (strong, nonatomic) NSMutableArray<XBArrangement *> *times;
/** 选择框 */
@property (strong, nonatomic) XBPickerView *pickerView;
/** 当前选择的IndexPath */
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
/** 下单的数据 */
@property (strong, nonatomic) XBArrangement *orderArrangement;
@end

static NSString *const reuseIdentifier = @"XBOrderCalendarCell";
@implementation XBOrderCalendarView


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

- (void)setArrangements:(NSArray<XBArrangement *> *)arrangements
{
    _arrangements = arrangements;
    
    [self reloadData];
}

- (void)reloadData
{
    self.lastMonthButton.hidden = ![self canShowMonthOperation:[self.arrangements firstObject]];
    
    self.nextMonthButton.hidden = ![self canShowMonthOperation:[self.arrangements lastObject]];
    
    [self setMonthLabelText];
    
    [self.calendarView reloadData];
}

- (void)initialization
{
    
    self.weeks = @[
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-mon"],
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-tue"],
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-wed"],
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-thu"],
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-fri"],
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-sat"],
                   [XBLanguageControl localizedStringForKey:@"activity-more-calendar-sun"],
                  ];
    
    self.currentDate = [NSDate date];
    
    self.calendar = [NSCalendar currentCalendar];
    
    self.canOrderIndexPaths = [NSMutableArray array];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.navigationBar = [[XBOrderNavigationBar alloc] initWithBackBlock:^{
        
        if ([self.delegate respondsToSelector:@selector(orderCalendarViewDidSelectDissmiss)]) {
            
            [self.delegate orderCalendarViewDidSelectDissmiss];
        }
        
    }];
    self.navigationBar.titleText = [XBLanguageControl localizedStringForKey:@"activity-order-chosedate"];
    [self addSubview:self.navigationBar];
    
    self.scrollView = [UIScrollView new];
    [self addSubview:self.scrollView];
    
    self.scrollContentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.scrollContentView];
    
    self.monthView = [UIView new];
    self.monthView.backgroundColor = [UIColor whiteColor];
    [self.scrollContentView addSubview:self.monthView];
    
    self.lastMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lastMonthButton setImage:[[UIImage imageNamed:@"left_arrow"] imageContentWithColor:[UIColor colorWithHexString:kDefaultColorHex]] forState:UIControlStateNormal];
    [self.lastMonthButton addTarget:self action:@selector(lastMonthAction) forControlEvents:UIControlEventTouchUpInside];
    [self.monthView addSubview:self.lastMonthButton];
    
    self.monthLabel = [UILabel new];
    self.monthLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-chosedate"];
    self.monthLabel.textColor = [UIColor blackColor];
    self.monthLabel.font = [UIFont boldSystemFontOfSize:19.f];
    [self.monthView addSubview:self.monthLabel];
    
    self.nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextMonthButton setImage:[[UIImage imageNamed:@"right_arrow"] imageContentWithColor:[UIColor colorWithHexString:kDefaultColorHex]] forState:UIControlStateNormal];
    [self.nextMonthButton addTarget:self action:@selector(nextMonthAction) forControlEvents:UIControlEventTouchUpInside];
    [self.monthView addSubview:self.nextMonthButton];
    
    self.calendarFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.calendarFlowLayout.minimumLineSpacing = 0.0;
    self.calendarFlowLayout.minimumInteritemSpacing = 0.0;

    self.calendarView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.calendarFlowLayout];
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    self.calendarView.showsVerticalScrollIndicator = NO;
    self.calendarView.showsHorizontalScrollIndicator = NO;
    self.calendarView.scrollEnabled = NO;
    self.calendarView.backgroundColor = [UIColor whiteColor];
    [self.calendarView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderCalendarCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    [self.scrollContentView addSubview:self.calendarView];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self.scrollContentView addSubview:self.separatorView];
    
    self.timeView = [UIView new];
    self.timeView.backgroundColor = [UIColor whiteColor];
    [self.scrollContentView addSubview:self.timeView];
    
    self.timeTitleLabel = [UILabel new];
    self.timeTitleLabel.font = [UIFont systemFontOfSize:17.f];
    self.timeTitleLabel.textColor = [UIColor colorWithHexString:@"#7F7F7F"];
    [self.timeView addSubview:self.timeTitleLabel];
    
    self.timeDetailLabel = [UILabel new];
    self.timeDetailLabel.font = [UIFont boldSystemFontOfSize:16.f];
    self.timeDetailLabel.textColor = [UIColor colorWithHexString:@"#565656"];
    [self.timeView addSubview:self.timeDetailLabel];
    
    self.timeTopSeparatorView = [UIView new];
    self.timeTopSeparatorView.hidden = YES;
    self.timeTopSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self.timeView addSubview:self.timeTopSeparatorView];
    
    self.timeBottomSeparatorView = [UIView new];
    self.timeBottomSeparatorView.hidden = YES;
    self.timeBottomSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self.timeView addSubview:self.timeBottomSeparatorView];
    
    self.orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.orderButton.enabled = NO;
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.layer.cornerRadius  = 8.f;
    self.orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.orderButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-order-chosedate"] forState:UIControlStateNormal];
    [self.orderButton setBackgroundColor:[UIColor colorWithHexString:@"#8E8E8E"]];
    [self.orderButton addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContentView addSubview:self.orderButton];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.pickerView = [[XBPickerView alloc] initWithFrame:keyWindow.bounds];
    self.pickerView.datasource = self;
    self.pickerView.delegate = self;
    self.pickerView.title = [XBLanguageControl localizedStringForKey:@"activity-order-time-begin-chose"];
    [keyWindow addSubview:self.pickerView];

    [self addConstraint];
}

- (void)addConstraint
{
    [self.navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.navigationBar.bottom);
        make.bottom.equalTo(self);
    }];
    
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
    }];
    
    [self.monthView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView);
        make.top.equalTo(self.scrollContentView);
        make.right.equalTo(self.scrollContentView);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.lastMonthButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.monthView);
        make.left.equalTo(self.monthView).offset(kSpace);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.monthView);
    }];
    
    [self.nextMonthButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.monthView);
        make.right.equalTo(self.monthView).offset(-kSpace);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.calendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView);
        make.right.equalTo(self.scrollContentView);
        make.top.equalTo(self.monthView.bottom);
        make.height.mas_equalTo(290);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView);
        make.right.equalTo(self.scrollContentView);
        make.top.equalTo(self.calendarView.bottom);
        make.height.mas_equalTo(0.7f);
    }];
    
    [self.timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView);
        make.right.equalTo(self.scrollContentView);
        make.top.equalTo(self.separatorView.bottom).offset(kSpace);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.timeTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView);
        make.left.equalTo(self.timeView).offset(kSpace * 1.5);
    }];
    
    [self.timeDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView);
        make.right.equalTo(self.timeView).offset(-kSpace * 1.5);
    }];
    
    [self.timeTopSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView);
        make.right.equalTo(self.timeView);
        make.top.equalTo(self.timeView);
        make.height.mas_equalTo(0.3f);
    }];
    
    [self.timeBottomSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView);
        make.right.equalTo(self.timeView);
        make.bottom.equalTo(self.timeView);
        make.height.mas_equalTo(0.7f);
    }];
    
    [self.orderButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView).offset(kSpace * 1.5);
        make.right.equalTo(self.separatorView).offset(-kSpace * 1.5);
        make.top.equalTo(self.timeView.bottom).offset(kSpace * 2);
        make.height.mas_equalTo(45.f);
        make.bottom.equalTo(self.scrollContentView).offset(-kSpace * 3.);
    }];
    
    [self.calendarView layoutIfNeeded];
    
    self.calendarFlowLayout.itemSize = CGSizeMake(self.calendarView.xb_width / 7,self.calendarView.xb_width / 7);
    
    self.calendarFlowLayout.minimumLineSpacing = 0.0;
    
    self.calendarFlowLayout.minimumInteritemSpacing = 0.0;

}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrangements.count > 0 ? 2 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.weeks.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBOrderCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.weeks[indexPath.row];
        
        cell.titleLabel.textColor = [UIColor blackColor];
        
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
        
        cell.highLightView.hidden = YES;
    
    } else {
        
        cell.titleLabel.textColor = [UIColor blackColor];
        
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        
        //获得本月第一天在星期几
        self.allDayArray = [NSMutableArray array];
        
        NSInteger day = [self currentFirstDay:self.currentDate];
        
        for (NSInteger i = 0; i < day; i++){
            
            [self.allDayArray addObject:@""];
        
        }
        
        NSInteger days = [self currentMonthOfDay:self.currentDate];
        
        for (NSInteger i = 1; i <= days; i++) {
        
            [self.allDayArray addObject:@(i)];
        
        }
        
        //把剩下的空间置为空
        for (NSInteger i = self.allDayArray.count; i < 42; i ++) {
        
            [self.allDayArray addObject:@""];
        
        }
        
        NSString *dayString = [NSString stringWithFormat:@"%@",self.allDayArray[indexPath.row]];
        
        cell.titleLabel.text = dayString;
        
        //是否为今天
        if ([self isToday:[dayString integerValue]]) {
            
            cell.subTitleLabel.hidden = NO;
            
            cell.subTitleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-more-calendar-today"];
            
            cell.subTitleLabel.tag = kTodayTag;
            
        } else {
            
            cell.subTitleLabel.hidden = YES;
            
            cell.subTitleLabel.tag = kUnTodayTag;
        }
        
        //是否可以下单
        if ([self dayIfCanOrder:[dayString integerValue]]) {
            
            cell.titleLabel.textColor = [UIColor blackColor];
            
            [self.canOrderIndexPaths addObject:indexPath];
            
        } else {
            
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#D4D4D4"];
        }
        
        NSDateComponents *currentComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
        
        //是否需要高亮
        if ([self.selectDay isEqualToString:[NSString stringWithFormat:@"%d-%02d-%02d",currentComp.year,currentComp.month,[dayString integerValue]]]) {
            
            [self orderCalendarCellIfHightlight:cell hightLight:YES];
            
        } else {
            
            cell.highLightView.hidden = YES;
            
        }
        
    }
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.canOrderIndexPaths containsObject:indexPath]) {
        
        self.currentIndexPath = indexPath;
    
        XBOrderCalendarCell *cell = (XBOrderCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [self orderCalendarCellIfHightlight:cell hightLight:YES];
        
        NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
        
        NSInteger day = [self.allDayArray[self.currentIndexPath.row] integerValue];
        
        self.selectDay = [NSString stringWithFormat:@"%d-%02d-%02d",comp.year,comp.month,day];
        
        
        self.times = [NSMutableArray array];
        
        //获取时间段
        for (XBArrangement *arrangement in self.arrangements) {
            
            if ([arrangement.startTime hasPrefix:self.selectDay]) {
               
                [self.times addObject:arrangement];
            }
            
        }
        
        //弹出选择框
        if (self.times.count > 1) {
            
            [self.pickerView reloadData];
            
            [self.pickerView toggle];
            
        } else {
            
            [self exchangeOrderButtonWithComp:comp day:day];
            
            self.orderArrangement = [self.times firstObject];
            
            self.orderArrangement.startTime = [[[self.orderButton titleForState:UIControlStateNormal] componentsSeparatedByString:@" "] lastObject];
            
        }
        
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.canOrderIndexPaths containsObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.canOrderIndexPaths containsObject:indexPath]) {
        
        XBOrderCalendarCell *cell = (XBOrderCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [self orderCalendarCellIfHightlight:cell hightLight:NO];
    }
}


#pragma mark -- XBPickerViewDatasource
- (NSInteger)numberOfComponentsInXBPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)xbPickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.times.count;
}

#pragma mark -- XBPickerViewDelegate
- (UIView *)xbPickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.text = [self formatterTimeStringAtIndex:row];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    
    return titleLabel;
}

- (CGFloat)xbPickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.f;
}

- (void)xbPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
    
    NSInteger day = [self.allDayArray[self.currentIndexPath.row] integerValue];
    
    [self exchangeOrderButtonWithComp:comp day:day];
    
    NSString *text = [self.orderButton titleForState:UIControlStateNormal];
    
    text = [text stringByAppendingString:[NSString stringWithFormat:@" %@",[self formatterTimeStringAtIndex:row]]];
    
    [self.orderButton setTitle:text forState:UIControlStateNormal];
    
    [self.timeView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45.f);
    }];
    
    self.timeTopSeparatorView.hidden = NO;
    
    self.timeBottomSeparatorView.hidden = NO;
    
    self.timeTitleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-time-begin-title"];
    
    self.timeDetailLabel.text = [self formatterTimeStringAtIndex:row];
    
    self.orderArrangement = self.times[row];
    
    NSArray<NSString *> *startTimes = [text componentsSeparatedByString:@" "];
    
    self.orderArrangement.startTime = [NSString stringWithFormat:@"%@ %@",startTimes[1],[startTimes lastObject]];

}


#pragma mark -- menthod
/** 修改下单按钮属性 */
- (void)exchangeOrderButtonWithComp:(NSDateComponents *)comp day:(NSInteger)day
{
    self.orderButton.enabled = YES;
    
    [self.orderButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    
    NSString *orderTitle = @"";
    
    if (![[XBUserDefaultsUtil currentLanguage] isEqualToString:kLanguageENUS]) {
        
        orderTitle = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-date"],comp.year,comp.month,day];
        
    } else {
        
        orderTitle = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-date"],[self monthOfString:comp.month],day,comp.year];
        
    }
    
    [self.orderButton setTitle:orderTitle forState:UIControlStateNormal];

}

/** 下单 */
- (void)orderAction
{
    DDLogDebug(@"下单 :%@",self.orderArrangement);
    
    if ([self.delegate respondsToSelector:@selector(orderCalendarView:didSelectOrderWithArrangement:)]) {
        
        [self.delegate orderCalendarView:self didSelectOrderWithArrangement:self.orderArrangement];
    }
}

/** 修改时间格式 */
- (NSString *)formatterTimeStringAtIndex:(NSInteger)index
{
    NSArray *times = [[[[[self.times[index].startTime componentsSeparatedByString:@"T"] lastObject] componentsSeparatedByString:@"+"] firstObject] componentsSeparatedByString:@":"];
    
    NSInteger hour = [[times firstObject] integerValue];
    
    NSInteger minute = [times[1] integerValue];
    
    NSString *text = hour - 12 > 0 ? [XBLanguageControl localizedStringForKey:@"activity-order-time-pm"] : [XBLanguageControl localizedStringForKey:@"activity-order-time-am"];
    
    hour = hour - 12 > 0 ? hour - 12 : hour;
    
    text = [NSString stringWithFormat:@"%@%d:%02d",text,hour,minute];
    
    return text;
}

/** 上个月 */
- (void)lastMonthAction
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents.month = -1;
    
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.currentDate options:0];
    
    self.currentDate = newDate;
    
    [self reloadData];
}

/** 下个月 */
- (void)nextMonthAction
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents.month = +1;
    
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.currentDate options:0];
    
    self.currentDate = newDate;
    
    [self reloadData];
}


/** 获取当前是哪一天 */
- (NSInteger)currentDay:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}
/** 本月有几天 */
- (NSInteger)currentMonthOfDay:(NSDate *)date{
    
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}
/** 本月第一天是星期几 */
- (NSInteger)currentFirstDay:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//1.mon
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/** 是否为今天 */
- (BOOL)isToday:(NSInteger)day
{
    NSDateComponents *currentComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
    
    NSDateComponents *dateComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];

    if (dateComp.month == currentComp.month && dateComp.day == day) {
        
        return YES;
    }
    
    return NO;
}

/** 转换成NSDateComponents */
- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date
{
    NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    return comp;
}

/** 日期是否可以下单 */
- (BOOL)dayIfCanOrder:(NSInteger)day
{
    
    NSDateComponents *currentComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date;
    
    for (XBArrangement *arrangement in self.arrangements) {
        
        date = [dateFormatter dateFromString:[[arrangement.startTime componentsSeparatedByString:@"T"] firstObject]];
        
        NSDateComponents *dateComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        
        if (dateComp.year == currentComp.year && dateComp.month == currentComp.month && dateComp.day == day) {
            
            return YES;
        }
    }
    
    return NO;
}

/** 是否可以显示 上个月 or 下个月 */
- (BOOL)canShowMonthOperation:(XBArrangement *)arrangement
{
    NSDateComponents *currentComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:[[arrangement.startTime componentsSeparatedByString:@"T"] firstObject]];
    
    NSDateComponents *dateComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];

    if (currentComp.year == dateComp.year && currentComp.month == dateComp.month) {
        
        return NO;
    }
    
    return YES;
}

/** 是否高亮 */
- (void)orderCalendarCellIfHightlight:(XBOrderCalendarCell *)cell hightLight:(BOOL)hightLight
{
    cell.highLightView.hidden = !hightLight;
    
    cell.subTitleLabel.hidden = hightLight ? YES : cell.subTitleLabel.tag == kUnTodayTag;
    
    cell.titleLabel.textColor = hightLight ? [UIColor whiteColor] : [UIColor blackColor];
    
}

- (void)setMonthLabelText
{
    NSDateComponents *currentComp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];
    
    NSString *dateString = @"";
    
    switch (currentComp.month) {
        case 1:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-jan"];
            break;
        case 2:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-feb"];
            break;
        case 3:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-mar"];
            break;
        case 4:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-apr"];
            break;
        case 5:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-may"];
            break;
        case 6:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-jun"];
            break;
        case 7:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-jul"];
            break;
        case 8:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-aug"];
            break;
        case 9:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-sep"];
            break;
        case 10:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-oct"];
            break;
        case 11:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-nov"];
            break;
        case 12:
            dateString = [XBLanguageControl localizedStringForKey:@"activity-order-calendar-dec"];
            break;
    }
    
    dateString = [dateString stringByAppendingString:[NSString stringWithFormat:@" %d",currentComp.year]];
    
    self.monthLabel.text = dateString;
    
}

- (NSString *)monthOfString:(NSInteger)month
{
    
    NSString *monthStr = @"";
    
    switch (month) {
        case 1:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-jan"];
            break;
        case 2:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-feb"];
            break;
        case 3:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-mar"];
            break;
        case 4:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-apr"];
            break;
        case 5:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-may"];
            break;
        case 6:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-jun"];
            break;
        case 7:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-jul"];
            break;
        case 8:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-aug"];
            break;
        case 9:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-sep"];
            break;
        case 10:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-oct"];
            break;
        case 11:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-nov"];
            break;
        case 12:
            monthStr = [XBLanguageControl localizedStringForKey:@"activity-order-select-dec"];
            break;
            
    }
    
    return monthStr;
}


@end
