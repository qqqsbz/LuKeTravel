//
//  XBExchangeViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBExchangeViewController.h"
#import "XBPickerView.h"
#import "XBExchange.h"
#import "XBUser.h"
@interface XBExchangeViewController () <XBPickerViewDelegate,XBPickerViewDatasource>
/** 语言标题 */
@property (strong, nonatomic) IBOutlet UILabel *languageTitleLabel;
/** 语言详细 */
@property (strong, nonatomic) IBOutlet UILabel *languageDetailLabel;
/** 货币标题 */
@property (strong, nonatomic) IBOutlet UILabel *currencyTitleLabel;
/** 货币详细 */
@property (strong, nonatomic) IBOutlet UILabel *currencyDetailLabel;
/** 所有分割线高度 */
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraints;
/** 选择框 */
@property (strong, nonatomic) XBPickerView     *pickerView;
/** 当选要修改类型的NSIndexPath */
@property (strong, nonatomic) NSIndexPath      *currentIndexPath;
/** 临时数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *datas;
/** 语言数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *languages;
/** 货币数据 */
@property (strong, nonatomic) NSArray<XBExchange *> *currencies;
/** 当前选择的数据 */
@property (strong, nonatomic) XBExchange            *currentExchange;
@end

@implementation XBExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillConfig];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeLanguageOrCurrency) name:kLoginSuccessNotificaton object:nil];
}

- (void)reloadData
{
    self.title = [XBLanguageControl localizedStringForKey:@"exchange-title"];
    
    self.languageTitleLabel.text = [XBLanguageControl localizedStringForKey:@"exchange-picker-language-title"];
    
    self.currencyTitleLabel.text = [XBLanguageControl localizedStringForKey:@"exchange-picker-currency-title"];

}

- (void)fillConfig
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        constraint.constant = 0.5f;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.pickerView = [[XBPickerView alloc] initWithFrame:keyWindow.bounds];
    
    self.pickerView.datasource = self;
    
    self.pickerView.delegate = self;
    
    [keyWindow addSubview:self.pickerView];
    
    //获取语言
    NSString *languagePath = [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"plist"];
    
    NSArray<XBExchange *> *languages = [XBExchange exchangeFromArray:[NSArray arrayWithContentsOfFile:languagePath]];
    
    self.languages = languages;
    
    for (XBExchange *language in languages) {
        if ([[XBUserDefaultsUtil currentLanguage] isEqualToString:language.desc]) {
            
            self.languageDetailLabel.text = [XBLanguageControl localizedStringForKey:language.text];
            
        }
    }
    
    //获取货币
    NSString *currencyPath = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    
    NSArray<XBExchange *> *currencies = [XBExchange exchangeFromArray:[NSArray arrayWithContentsOfFile:currencyPath]];
    
    self.currencies = currencies;
    
    [self fillText];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return;
    
    self.currentIndexPath = indexPath;
    
    if (indexPath.row == 1) {
    
        self.datas = self.languages;
        
    } else if (indexPath.row == 2) {
        
        self.datas = self.currencies;
        
    }
    
    [self.pickerView reloadData];
    
    [self fillSelectRow:self.pickerView.xbPickView];
    
    [self.pickerView toggle];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.text = [XBLanguageControl localizedStringForKey:change.text];
    
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
    self.currentExchange = self.datas[row];
    
    [self exchangeLanguageOrCurrency];
}

- (void)exchangeLanguageOrCurrency
{
    if ([XBUserDefaultsUtil userInfo]) {
        
        [self showLoadinngInView:self.view];
        
        if (self.currentIndexPath.row == 1) {
            
            [[XBHttpClient shareInstance] updateLanguageWithLanguage:self.currentExchange.desc success:^(BOOL isSuccess) {
                
                [self reloadDataWithExchange:self.currentExchange isLanguage:YES];
                
                [self hideLoading];
                
                [self showSuccess:@""];
                
            } failure:^(NSError *error) {
                
                [self hideLoading];
                
                if (error.code == kUserUnLoginCode) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserUnLoginNotification object:nil];
                    
                } else {
                    
                    [self showFail:@""];
                }
                
            }];
            
        } else if (self.currentIndexPath.row == 2) {
            
            [[XBHttpClient shareInstance] updateCurrencyWithCurrency:self.currentExchange.text success:^(BOOL isSuccess) {
                
                [self reloadDataWithExchange:self.currentExchange isLanguage:NO];
                
                [self hideLoading];
                
                [self showSuccess:@""];
                
            } failure:^(NSError *error) {
                
                [self hideLoading];
                
                if (error.code == kUserUnLoginCode) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserUnLoginNotification object:nil];
                    
                } else {
                    
                    [self showFail:@""];
                }
                
            }];
            
        }
        
    } else {
        
        [self reloadDataWithExchange:self.currentExchange isLanguage:self.currentIndexPath.row == 1];
    }

}

- (void)fillSelectRow:(UIPickerView *)pickerView
{
    XBExchange *exchange;
    
    for (NSInteger i = 0; i < self.datas.count ; i ++) {
        
        exchange = self.datas[i];
        
        if (self.currentIndexPath.row == 1 && [exchange.desc isEqualToString:[XBUserDefaultsUtil currentLanguage]]) {
            
            [pickerView selectRow:i inComponent:0 animated:NO];
            
        } else if (self.currentIndexPath.row == 2 && [exchange.text isEqualToString:[XBUserDefaultsUtil currentCurrency]]) {
            
            [pickerView selectRow:i inComponent:0 animated:NO];
            
        }
        
    }
}

- (void)reloadDataWithExchange:(XBExchange *)change isLanguage:(BOOL)isLanguage
{
    if (isLanguage) {
        
        [XBUserDefaultsUtil updateCurrentLanguage:change.desc];
        
        [XBLanguageControl setUserlanguage:change.text];
        
        [self.pickerView reloadLanguageConfig];
        
        [self reloadData];
        
    } else {
        
        [XBUserDefaultsUtil updateCurrentCurrency:change.text];
        
        [XBUserDefaultsUtil updateCurrentCurrencySymbol:change.desc];
        
    }
    
    [self fillText];

}

- (void)fillText
{
    for (XBExchange *language in self.languages) {
        if ([[XBUserDefaultsUtil currentLanguage] isEqualToString:language.desc]) {
            
            self.languageDetailLabel.text = [XBLanguageControl localizedStringForKey:language.text];
            
        }
    }
    
    for (XBExchange *currency in self.currencies) {
        if ([[XBUserDefaultsUtil currentCurrency] isEqualToString:currency.text]) {
            
            self.currencyDetailLabel.text = [XBLanguageControl localizedStringForKey:currency.text];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
