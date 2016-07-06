//
//  StretchableTableHeaderView.m
//  StretchableTableHeaderView
//
#define kSpace 10.f
#import "XBStretchableTableHeaderView.h"


@interface XBStretchableTableHeaderView()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@property (strong, nonatomic) UIView   *contentView;
@end


@implementation XBStretchableTableHeaderView

@synthesize tableView = _tableView;
@synthesize view = _view;

- (void)stretchHeaderForTableView:(UITableView *)tableView withView:(UIView *)view
{
    _tableView = tableView;
    _view      = view;
    
    initialFrame       = _view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView *emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    
    self.contentView = [[UIView alloc] initWithFrame:view.bounds];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"探索未知的你";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.f];
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.text = @"发现更好玩的世界，预订独一无二的旅行体验";
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:self.subTitleLabel];
    
    _tableView.tableHeaderView = emptyTableHeaderView;

    [_tableView addSubview:_view];
    [_tableView addSubview:self.contentView];

    [self addConstraint];
}


- (void)addConstraint
{
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace);
        make.bottom.equalTo(self.contentView).offset(-kSpace * 2.5f);
        make.right.equalTo(self.contentView).offset(-kSpace * 2);;
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitleLabel);
        make.right.equalTo(self.subTitleLabel);
        make.bottom.equalTo(self.subTitleLabel.top).offset(-kSpace * 0.3);
    }];
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f     = _view.frame;
    f.size.width = _tableView.frame.size.width;
    _view.frame  = f;
    
    if(scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
       
        initialFrame.origin.y = - offsetY * 1;
        
        initialFrame.size.height = defaultViewHeight + offsetY;
        
        _view.frame = initialFrame;
    }

}


- (void)resizeView
{
    initialFrame.size.width = _tableView.frame.size.width;
    _view.frame = initialFrame;
}


@end
