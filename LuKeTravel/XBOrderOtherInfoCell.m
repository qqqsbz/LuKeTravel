//
//  XBOrderOtherInfoCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderOtherInfoCell.h"
#import "XBBookOtherInfo.h"
@interface XBOrderOtherInfoCell()<UITextFieldDelegate>
@end
@implementation XBOrderOtherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        
        constraint.constant = 0.5;
    }
    
    self.textField.delegate = self;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [[NSString stringWithFormat:@"%@%@",textField.text,string] clearBlack];
    
    text = [string isEqualToString:@""] ? [text substringToIndex:text.length - 1] : text;
    
    self.otherInfo.content = text;
    
    return YES;
}

- (void)setOtherInfo:(XBBookOtherInfo *)otherInfo
{
    _otherInfo = otherInfo;
    
    self.titleLabel.text = otherInfo.typeName;
    
    self.textField.placeholder = otherInfo.listFormat ? [[otherInfo.typeHint componentsSeparatedByString:@","] firstObject] : otherInfo.typeHint;
    
    self.textField.userInteractionEnabled = !(otherInfo.listFormat || otherInfo.dateFormat);
}

- (void)setBecomeFirstResponder:(BOOL)becomeFirstResponder
{
    _becomeFirstResponder = becomeFirstResponder;
    
    if (self.textField.isUserInteractionEnabled && becomeFirstResponder) {
        
        [self.textField becomeFirstResponder];
    }
}

- (void)setPickerString:(NSString *)pickerString
{
    _pickerString = pickerString;
    
    self.otherInfo.content = pickerString;
    
    self.textField.text = pickerString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
