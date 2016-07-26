
//
//  XBActivityReviewCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivityReviewCell.h"
#import "XBComment.h"
#import "UIImage+Util.h"
@implementation XBActivityReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorConstraint.constant = 0.7f;
}

- (void)setComment:(XBComment *)comment
{
    _comment = comment;
    
    self.contentLabel.text = comment.content;
    
    self.nickNameLabel.text = comment.name;
    
    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [descAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.contentLabel.text.length)];
    
    self.contentLabel.attributedText = descAttributedString;
    
    UIImageView *imageView;
    
    UIColor *defaultColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    for (NSInteger i = 0; i < self.starImageViews.count; i ++) {
    
        imageView = self.starImageViews[i];
        
        if (i < comment.rating) {
            
            imageView.image = [[UIImage imageNamed:@"star-highlighted-template"] imageContentWithColor:defaultColor];
        
        } else {
            
            imageView.image = [[UIImage imageNamed:@"star-template"] imageContentWithColor:defaultColor];
            
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
