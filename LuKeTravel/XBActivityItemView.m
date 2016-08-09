
//
//  XBActivityItemView.m
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kLineSpacing 7.f

#import "XBActivityItemView.h"
#import "XBRange.h"
#import "XBParserContentItem.h"
@interface XBActivityItemView() <TTTAttributedLabelDelegate>
@property (strong, nonatomic) TTTAttributedLabel   *attributedLabel;
@end
@implementation XBActivityItemView

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
    self.attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.attributedLabel.lineSpacing = kLineSpacing;
    self.attributedLabel.numberOfLines = 0;
    self.attributedLabel.font = [UIFont systemFontOfSize:15.f];
    self.attributedLabel.textColor = [UIColor colorWithHexString:@"#6C6C6B"];
    self.attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.attributedLabel.delegate = self;
    [self addSubview:self.attributedLabel];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kSpace * 0.6, kSpace) radius:2.f startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    [self.layer addSublayer:shapeLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.attributedLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 2.1);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setParserContentItem:(XBParserContentItem *)parserContentItem
{
    _parserContentItem = parserContentItem;
    
    if (parserContentItem.text && parserContentItem.text.length > 0) {
        
        self.attributedLabel.text = parserContentItem.text;
        
    } else {
        
        self.attributedLabel.hidden = YES;
        
    }
    
    if (parserContentItem.linkString && parserContentItem.linkString.length > 0) {
        
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        
        [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        
        [linkAttributes setValue:(__bridge id)[UIColor colorWithHexString:@"#69BAF2"].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        
        self.attributedLabel.linkAttributes = linkAttributes;
        
        [self.attributedLabel addLinkToURL:[NSURL URLWithString:parserContentItem.linkString] withRange:NSMakeRange(parserContentItem.range.location, parserContentItem.range.length)];
        
    }
}

#pragma mark -- TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(activityItemView:didSelectLinkWithURL:)]) {
        [self.delegate activityItemView:self didSelectLinkWithURL:url];
    }
}

@end
