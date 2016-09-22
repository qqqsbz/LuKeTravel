//
//  XBLaunchScreenViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBLaunchScreenViewController.h"
#import "XBGuideView.h"
@interface XBLaunchScreenViewController ()
/** 菊花 */
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation XBLaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self buildView];
}

- (void)buildView
{
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.indicatorView.center = CGPointMake(self.view.center.x, self.view.xb_height - kSpace * 2.5);
    
    [self.indicatorView startAnimating];
    
    [self.view addSubview:self.indicatorView];
}

- (void)startIndicatorView
{
    [self.view bringSubviewToFront:self.indicatorView];
    
    [self.indicatorView startAnimating];
}

- (void)showGuideViewWithComplete:(dispatch_block_t)complete
{
    //是否是第一次启动app
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    NSArray<UIImage *>  *images = @[[UIImage imageNamed:@"guide1"],
                                    [UIImage imageNamed:@"guide2"],
                                    [UIImage imageNamed:@"guide3"]
                                    ];
    
    NSArray<NSString *> *titles = @[[XBLanguageControl localizedStringForKey:@"guide-first-title"],
                                    [XBLanguageControl localizedStringForKey:@"guide-second-title"],
                                    [XBLanguageControl localizedStringForKey:@"guide-third-title"]
                                    ];
    
    NSArray<NSString *> *contents = @[[XBLanguageControl localizedStringForKey:@"guide-first-content"],
                                      [XBLanguageControl localizedStringForKey:@"guide-second-content"],
                                      [XBLanguageControl localizedStringForKey:@"guide-third-content"]
                                      ];
    
    XBGuideView *guideView = [[XBGuideView alloc] initWithFrame:keyWindow.bounds images:images titles:titles contents:contents complete:^{
        
        if (complete) {
            
            complete();
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [XBUserDefaultsUtil updateAlreadyFirstStart:YES];
    }];
    
    [keyWindow addSubview:guideView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
