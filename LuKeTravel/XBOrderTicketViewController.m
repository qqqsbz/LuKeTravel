//
//  XBOrderTicketViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kHeaderHeight 50

#import "XBOrderTicketViewController.h"
#import "XBBook.h"
#import "XBExchange.h"
#import "XBBookTicket.h"
#import "XBPayContact.h"
#import "XBPickerView.h"
#import "RegexKitLite.h"
#import "XBArrangement.h"
#import "XBCountryView.h"
#import "XBOrderNextView.h"
#import "XBBookOtherInfo.h"
#import "XBDatePickerView.h"
#import "XBOrderTicketCell.h"
#import "XBOrderOtherInfoCell.h"
#import "XBOrderTicketHeaderCell.h"
#import "XBOrderTicketHeaderView.h"
#import "XBOrderTicketTransition.h"
#import "XBBookOrderViewController.h"
#import "XBOrderTicketNavigationBar.h"
#import "XBOrderPrePayViewController.h"
#import "XBOrderCalendarViewController.h"
@interface XBOrderTicketViewController ()<XBPickerViewDatasource,XBPickerViewDelegate,XBOrderTicketCellDelegate,XBDatePickerViewDelegate>

/** 选择框 */
@property (strong, nonatomic) XBPickerView  *pickerView;
/** 时间选择框*/
@property (strong, nonatomic) XBDatePickerView *datePickerView;
/** 当前选中的输入框 */
@property (strong, nonatomic) NSIndexPath   *currentIndexPath;

/** 称谓数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *appellations;
/** 国家数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *countries;
/** 临时数据 用于切换 称谓、国家之间的数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *datas;

/** contentSize Height */
@property (assign, nonatomic) CGFloat  contentSizeHeight;

/** tableView y */
@property (assign, nonatomic) CGFloat  tableViewY;

/** 是否跳转到支付界面 */
@property (assign, nonatomic,getter=isForPrePay) BOOL  forPrePay;

@end

static NSString *const basicReuseIdentifier = @"XBOrderTicketCell";
static NSString *const otherInfoReuseIdentifier = @"XBOrderOtherInfoCell";
static NSString *const headerReuseIdentifier = @"XBOrderTicketHeaderCell";
@implementation XBOrderTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillData];
    
    [self buildView];
    
    [self fillOrderTicketNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:self.orderTicketNavigationBar];
    
    self.navigationItem.hidesBackButton = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.orderTicketNavigationBar removeFromSuperview];
    
    self.navigationItem.hidesBackButton = self.isForPrePay;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:self.isForPrePay ? 0 : 1];
    
    [self hideLoading];
    
}

- (void)setBook:(XBBook *)book
{
    _book = book;
    
    if (self.orderTicketNavigationBar) {
        
        [self fillData];
        
        [self fillOrderTicketNavigationBar];
        
        [self.tableView reloadData];
        
        self.tableView.xb_y = self.tableViewY;
    }
}

- (void)sendRequest
{
    
    XBPayContact *payContact = self.book.payContact;
    
    NSString *appellation = [payContact.title clearBlack];
    
    NSString *name = [payContact.firstName clearBlack];
    
    NSString *family = [payContact.familyName clearBlack];
    
    NSString *email = [payContact.travellerEmail clearBlack];
    
    NSString *code = [[[payContact.mobile componentsSeparatedByString:@"-"] firstObject] clearBlack];
    
    NSString *phone = [[[payContact.mobile componentsSeparatedByString:@"-"] lastObject] clearBlack];
    
    NSRange emailRange = [email rangeOfRegex:kEmailRegex];
    
    if (name.length <= 0 || family.length <= 0 || email.length <= 0 || code.length <= 0 || phone.length <= 0 || [appellation isEqualToString:[XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"]]) {
        
        [self showAlertWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-error-all-field"]];
        
        return;
        
    } else if (emailRange.location == NSNotFound) {
        
        [self showEmptyError];
        
        return;
        
    } else {
        
        NSArray<XBBookOtherInfo *> *otherInfos = [self.book.bookTickets firstObject].generalOtherInfos;
        
        BOOL isEmpty = NO;
        
        for (XBBookOtherInfo *otherInfo in otherInfos) {
            
            if ([otherInfo.content clearBlack].length <= 0) {
                
                isEmpty = YES;
            }
        }
        
        if (isEmpty) {
            
            [self showEmptyError];
            
            return;
        }
    }
    
    NSInteger ticketId = [[self.book.bookTickets firstObject].modelId integerValue];
    
    NSString *otherInfoString = @"";
    
    if ([self.book.bookTickets firstObject].generalOtherInfos.count > 0) {
        
        NSArray<XBBookOtherInfo *> *otherInfos = [self.book.bookTickets firstObject].generalOtherInfos;
        
        NSArray *array = [MTLJSONAdapter JSONArrayFromModels:otherInfos];
        
        NSError *error;
        
        NSData *data;
        
        for (NSDictionary *dic in array) {
            
            data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            
            otherInfoString = [otherInfoString stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            
            otherInfoString = [otherInfoString stringByAppendingString:@","];
            
        }
        
        otherInfoString = [otherInfoString substringToIndex:otherInfoString.length - 1];
        
    }
    
    [self showLoadinng];
    
    [[XBHttpClient shareInstance] payTypeWithPayContact:payContact ticketId:ticketId otherInfo:otherInfoString success:^(XBBook *book) {
        
        XBOrderPrePayViewController *prePayVC = [[XBOrderPrePayViewController alloc] init];
        
        book.payContact = payContact;
        
        prePayVC.book = book;
        
        self.navigationController.delegate = prePayVC;
        
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        
        [self.navigationController pushViewController:prePayVC animated:YES];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        NSString *errorMsg = @"";
        
        if (error.code == kPhoneErrorUsedCode || error.code == kOrderUnExistCode) {
            
            errorMsg = [error.userInfo valueForKey:kErrorMessage];
            
        } else {
            
            errorMsg = [XBLanguageControl localizedStringForKey:@"error-no-network-signal"];
        }
        
         [self showAlertWithTitle:errorMsg];
        
    }];
    
}

- (void)fillData
{
    self.appellations = @[
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-chose"] text:@"" desc:nil],
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mr"] text:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mr"] desc:nil],
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mrs"] text:[XBLanguageControl localizedStringForKey:@"user-info-appellation-mrs"] desc:nil],
                          [XBExchange exchangeWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-appellation-miss"] text:[XBLanguageControl localizedStringForKey:@"user-info-appellation-miss"] desc:nil]
                          ];
    
    //获取语言
    NSString *countryPath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    
    self.countries = [XBExchange exchangeFromArray:[NSArray arrayWithContentsOfFile:countryPath]];
}

- (void)buildView
{
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderTicketCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:basicReuseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderOtherInfoCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:otherInfoReuseIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBOrderTicketHeaderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:headerReuseIdentifier];
    
    XBOrderNextView *nextView = [[XBOrderNextView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.xb_width, 85) nextBlock:^{
        
        if (self.book) {
            
            [self sendRequest];
            
            self.tableView.xb_y = self.tableViewY ;
        }
        
    }];
    nextView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = nextView;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.pickerView = [[XBPickerView alloc] initWithFrame:keyWindow.bounds];
    
    self.pickerView.datasource = self;
    
    self.pickerView.delegate = self;
    
    self.pickerView.hideTitle = YES;
    
    self.pickerView.hideCancle = YES;
    
    self.pickerView.pickerColor = [UIColor colorWithHexString:@"#D0D5DA"];
    
    self.pickerView.backgroundColor = [UIColor clearColor];
    
    self.pickerView.navigationBarColor = [UIColor colorWithHexString:@"#E7E7E7"];
    
    [keyWindow addSubview:self.pickerView];
    
    self.datePickerView = [[XBDatePickerView alloc] initWithFrame:keyWindow.bounds];
    
    self.datePickerView.delegate = self;
    
    [keyWindow addSubview:self.datePickerView];
    
    self.orderTicketNavigationBar = [[XBOrderTicketNavigationBar alloc] initWithFrame:CGRectMake(kSpace, 0, self.view.xb_width - kSpace * 2, 90.f) popBlock:^{
        
        //修复从准备支付界面跳转回来不执行"转场动画"的bug
        self.navigationController.delegate = self;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    self.orderTicketNavigationBar.layer.shadowColor = [UIColor redColor].CGColor;
    
    self.orderTicketNavigationBar.layer.shadowOffset = CGSizeMake(200,200);
    
    self.orderTicketNavigationBar.layer.shadowOpacity = 1;//阴影透明度，默认0
    
    self.orderTicketNavigationBar.layer.shadowRadius = 150;//阴影半径，默认3
    
    self.orderTicketNavigationBar.backgroundColor = [UIColor whiteColor];
    
    self.orderTicketNavigationBar.layer.masksToBounds = YES;
    
    self.orderTicketNavigationBar.layer.cornerRadius  = 5.f;
    
    self.contentSizeHeight = self.tableView.contentSize.height;
    
    self.tableViewY = self.tableView.xb_y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.book.bookTickets firstObject].generalOtherInfos.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 7 : [self.book.bookTickets firstObject].generalOtherInfos.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if (indexPath.row == 0) {
        
        XBOrderTicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        
        cell.titleLabel.text = indexPath.section == 0 ? [XBLanguageControl localizedStringForKey:@"activity-order-basic"] : [XBLanguageControl localizedStringForKey:@"activity-order-special"];
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        
        XBOrderTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:basicReuseIdentifier forIndexPath:indexPath];
        
        cell.topSeparator.hidden = indexPath.row != 1;
        
        cell.bottomSeparator.hidden = indexPath.row != 6;
        
        cell.contentSeparator.hidden = indexPath.row == 6;
        
        cell.type = indexPath.row - 1;
        
        cell.book = self.book;
        
        cell.delegate = self;
        
        return cell;
    }
    
    XBOrderOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:otherInfoReuseIdentifier forIndexPath:indexPath];
    
    cell.otherInfo = [self.book.bookTickets firstObject].generalOtherInfos[indexPath.row - 1];
    
    cell.topSeparator.hidden = indexPath.row != 1;
    
    cell.bottomSeparator.hidden = indexPath.row != [self.book.bookTickets firstObject].generalOtherInfos.count;
    
    cell.contentSeparator.hidden = indexPath.row == [self.book.bookTickets firstObject].generalOtherInfos.count;
    
    return cell;
}

#pragma mark -- Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return;
    
    self.currentIndexPath = indexPath;
    
    if (indexPath.section == 0) {
        
        XBOrderTicketCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.orderTicketFirstResponder = YES;
        
        if (indexPath.row == 1) {
            
            if (self.datePickerView.isShow) {
                
                [self.datePickerView toggle];
            }
            
            if (!self.pickerView.isShow) {
                
                [self.pickerView toggle];
            }
            
            //防止键盘挡住选择框
            [self.view endEditing:YES];
            
            self.datas = self.appellations;
            
            [self.pickerView reloadData];
            
        }
    } else {
        
        XBBookOtherInfo *otherInfo = [self.book.bookTickets firstObject].generalOtherInfos[indexPath.row - 1];
        
        XBOrderOtherInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.becomeFirstResponder = YES;
        
        if (otherInfo.listFormat) {
            
            NSMutableArray *exchanges = [NSMutableArray array];
            
            for (NSString *string in [otherInfo.typeHint componentsSeparatedByString:@","]) {
            
                [exchanges addObject:[XBExchange exchangeWithTitle:string text:string desc:string]];
            }
            
            if (self.datePickerView.isShow) {
                
                [self.datePickerView toggle];
            }
            
            if (!self.pickerView.isShow) {
                
                [self.pickerView toggle];
            }
            
            //防止键盘挡住选择框
            [self.view endEditing:YES];
            
            self.datas = exchanges;
            
            [self.pickerView reloadData];
            
        } else if (otherInfo.dateFormat) {
            
            //隐藏选择框
            if (self.pickerView.isShow) {
                
                [self.pickerView toggle];
            }
            
            [self.datePickerView toggle];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 50.f : 44.f;
}


#pragma mark -- XBOrderTicketCellDelegate
- (void)orderTicketCell:(XBOrderTicketCell *)orderTicketCell didSelectCountryCodeWithBook:(XBBook *)book
{
    self.currentIndexPath = [self.tableView indexPathForCell:orderTicketCell];
    
    if (!self.pickerView.isShow) {
        
        [self.pickerView toggle];
    }
    
    //防止键盘挡住选择框
    [self.view endEditing:YES];
    
    self.datas = self.countries;
    
    [self.pickerView reloadData];
}

#pragma mark -- XBPickerViewDatasource
- (NSInteger)numberOfComponentsInXBPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)xbPickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.datas.count;
}

#pragma mark -- XBPickerViewDelegate
- (UIView *)xbPickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    XBExchange *change = self.datas[row];
    
    if (self.currentIndexPath.section == 0) {
        
        if (self.currentIndexPath.row == 1) {
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            
            titleLabel.text = [XBLanguageControl localizedStringForKey:change.title];
            
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            titleLabel.font = [UIFont systemFontOfSize:17.f];
            
            return titleLabel;
        }
        
        XBCountryView *countryView = [[XBCountryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.pickerView.frame), 35.f)];
        
        countryView.imageView.image = [UIImage imageNamed:change.desc];
        
        countryView.titleLabel.text = [XBLanguageControl localizedStringForKey:change.text];
        
        return countryView;

    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.text = change.text;
    
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
    
    XBExchange *change = self.datas[row];
    
    if (self.currentIndexPath.section == 0) {
        
        if (self.currentIndexPath.section == 0)
        {
            XBOrderTicketCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
            
            cell.pickerString = change.text;
        }

    } else if (self.currentIndexPath.section == 1 && row != 0) {
        
        XBOrderOtherInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        
        cell.pickerString = change.text;
        
    }
}


#pragma mark -- XBDatePickerViewDelegate
- (void)datePickerView:(XBDatePickerView *)datePickerView didDoneWithDate:(NSDate *)date
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    XBOrderOtherInfoCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    
    cell.pickerString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-otherinfo-date"],[NSIntegerFormatter formatToNSString:comp.year],[NSIntegerFormatter formatToNSString:comp.month],[NSIntegerFormatter formatToNSString:comp.day]];
}


- (void)fillOrderTicketNavigationBar
{
    XBBookTicket *bookTicket = [self.book.bookTickets firstObject];
    
    self.orderTicketNavigationBar.titleLabel.text = bookTicket.packageDesc;
    
    self.orderTicketNavigationBar.markerLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.marketPrice];
    
    self.orderTicketNavigationBar.sellLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],bookTicket.ticketPrice];
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.orderTicketNavigationBar.markerLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    
    self.orderTicketNavigationBar.markerLabel.attributedText = attribtStr;
    
    NSString *count = @"";
    
    for (NSString *ticket in bookTicket.ticketTypeCounts) {
        
        count = [count stringByAppendingString:[NSString stringWithFormat:@"%@,",ticket]];
        
    }
    
    self.orderTicketNavigationBar.countLabel.text = [count substringToIndex:count.length - 1];
    
    
    NSArray *dateStrings = [[[bookTicket.arrangement.startTime componentsSeparatedByString:@"T"] firstObject] componentsSeparatedByString:@"-"];
    
    NSString *dateString = @"";
    
    if (dateStrings.count == 3) {
        
        if (![[XBUserDefaultsUtil currentLanguage] isEqualToString:kLanguageENUS]) {
            
            dateString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-ticket-date"],[dateStrings firstObject],dateStrings[1],[dateStrings lastObject]];
            
        } else {
            
            dateString = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"activity-order-date"],[NSString monthOfStringForENUS:[dateStrings[1] integerValue]],[dateStrings lastObject],[dateStrings firstObject]];
            
        }

    }
    
    self.orderTicketNavigationBar.dateLabel.text = dateString;
}



/** 转场动画 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    NSString *fromVCString = NSStringFromClass([fromVC class]);
    
    NSString *toVCString = NSStringFromClass([toVC class]);
    
    if (([fromVCString isEqualToString:NSStringFromClass([XBBookOrderViewController class])] && [toVCString isEqualToString:NSStringFromClass([XBOrderTicketViewController class])]) || ([fromVCString isEqualToString:NSStringFromClass([XBOrderTicketViewController class])] && [toVCString isEqualToString:NSStringFromClass([XBBookOrderViewController class])])) {
        
        self.forPrePay = YES;
        
        return [XBOrderTicketTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBOrderTicketTransitionTypePush : XBOrderTicketTransitionTypePop];
        
    }
    
    self.forPrePay = NO;
    
    return nil;
}

- (void)showEmptyError
{
    [self showAlertWithTitle:[XBLanguageControl localizedStringForKey:@"user-info-error-all-field"]];
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.contentSizeHeight+ 90);
    });
}

@end
