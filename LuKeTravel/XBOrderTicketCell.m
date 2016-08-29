//
//  XBOrderConfirmBasicCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderTicketCell.h"
#import "XBBook.h"
#import "XBPayContact.h"
@interface XBOrderTicketCell() <UITextFieldDelegate>
@end
@implementation XBOrderTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        
        constraint.constant = 0.5f;
        
    }
    
    self.textField.delegate = self;
    
}

- (void)setType:(XBOrderTicketType)type
{
    _type = type;
    
    switch (type) {
        case XBOrderTicketTypeTitle:
        {
            self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-appellation"];
            
            self.textField.placeholder = [XBLanguageControl localizedStringForKey:@"user-info-appellation-placeholder"];
            
            self.pSeparatorView.hidden = YES;
            
            self.pullButton.hidden = YES;
            
            self.verifityLabel.hidden = YES;
            
            self.textFieldRightConstraints.constant = kSpace;
            
            self.textField.userInteractionEnabled = NO;
            
        }
            break;
        case XBOrderTicketTypeFirstName:
        {
            self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-name"];
            
            self.textField.placeholder = [XBLanguageControl localizedStringForKey:@"user-info-name-placeholder"];
            
            self.pSeparatorView.hidden = YES;
            
            self.pullButton.hidden = YES;
            
            self.verifityLabel.hidden = YES;
            
            self.textFieldRightConstraints.constant = kSpace;
        }
            break;
        case XBOrderTicketTypeFamily:
        {
            self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-family"];
            
            self.textField.placeholder = [XBLanguageControl localizedStringForKey:@"user-info-family-placeholder"];
            
            self.pSeparatorView.hidden = YES;
            
            self.pullButton.hidden = YES;
            
            self.verifityLabel.hidden = YES;
            
            self.textFieldRightConstraints.constant = kSpace;
        }
            break;
        case XBOrderTicketTypeEmail:
        {
            self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-email"];
            
            self.textField.placeholder = [XBLanguageControl localizedStringForKey:@"user-info-email-placeholder"];
            
            self.pSeparatorView.hidden = YES;
            
            self.pullButton.hidden = YES;
            
            self.verifityLabel.hidden = YES;
            
            self.textFieldRightConstraints.constant = kSpace;
        }
            break;
        case XBOrderTicketTypeCountryCode:
        {
            self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-code"];
            
            self.textField.placeholder = [XBLanguageControl localizedStringForKey:@"user-info-code-placeholder"];
            
            self.pSeparatorView.hidden = NO;
            
            self.pullButton.hidden = NO;
            
            self.verifityLabel.hidden = YES;
            
            self.textFieldRightConstraints.constant = self.xb_width - self.pSeparatorView.xb_x + kSpace;
        }
            break;
        case XBOrderTicketTypePhone:
        {
            self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-phone"];
            
            self.textField.placeholder = [XBLanguageControl localizedStringForKey:@"user-info-phone-placeholder"];
            
            self.pSeparatorView.hidden = YES;
            
            self.pullButton.hidden = YES;
            
            self.verifityLabel.hidden = NO;
            
            self.verifityLabel.text = [XBLanguageControl localizedStringForKey:@"user-info-code-verified"];
            
            self.textFieldRightConstraints.constant = self.xb_width - self.verifityLabel.xb_x;
        }
            break;
    }
}

- (void)setBook:(XBBook *)book
{
    _book = book;
    
    if (!book.payContact) return;
    
    XBPayContact *payContact = book.payContact;
    
    switch (self.type) {
        case XBOrderTicketTypeTitle:
        {
            self.textField.text = payContact.title;
        }
            break;
        case XBOrderTicketTypeFirstName:
        {
            self.textField.text = payContact.firstName;
        }
            break;
        case XBOrderTicketTypeFamily:
        {
            self.textField.text = payContact.familyName;
        }
            break;
        case XBOrderTicketTypeEmail:
        {
            self.textField.text = payContact.travellerEmail;
        }
            break;
        case XBOrderTicketTypeCountryCode:
        {
            self.textField.text = [NSString stringWithFormat:@"+%@",[[payContact.mobile componentsSeparatedByString:@"-"] firstObject]];
        }
            break;
        case XBOrderTicketTypePhone:
        {
            self.textField.text = [[payContact.mobile componentsSeparatedByString:@"-"] lastObject];
            
            self.verifityLabel.hidden = !book.mobileVerifyStatus;
            
            self.textFieldRightConstraints.constant = book.mobileVerifyStatus ? self.xb_width - self.verifityLabel.xb_x : kSpace;
        }
            break;
    }
}

- (void)setOrderTicketFirstResponder:(BOOL)orderTicketFirstResponder
{
    _orderTicketFirstResponder = orderTicketFirstResponder;
    
    if (orderTicketFirstResponder) {
        
        [self.textField becomeFirstResponder];
    }
}

- (void)setPickerString:(NSString *)pickerString
{
    _pickerString = pickerString;
    
    if (self.type == XBOrderTicketTypeTitle) {
        
        self.book.payContact.title = pickerString;
        
        self.textField.text = pickerString;
        
    } else if (self.type == XBOrderTicketTypeCountryCode) {
        
        self.book.payContact.mobile = [NSString stringWithFormat:@"%@-%@",pickerString,[[self.book.payContact.mobile componentsSeparatedByString:@"-"] lastObject]];
        
        self.textField.text = [NSString stringWithFormat:@"+%@",pickerString];
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [[NSString stringWithFormat:@"%@%@",textField.text,string] clearBlack];
    
    text = [string isEqualToString:@""] ? [text substringToIndex:text.length - 1] : text;

    switch (self.type) {
        case XBOrderTicketTypeTitle:
        {
        }
            break;
        case XBOrderTicketTypeFirstName:
        {
            self.book.payContact.firstName = text;
        }
            break;
        case XBOrderTicketTypeFamily:
        {
            self.book.payContact.familyName = text;
        }
            break;
        case XBOrderTicketTypeEmail:
        {
            self.book.payContact.travellerEmail = text;
        }
            break;
        case XBOrderTicketTypeCountryCode:
        {
        }
            break;
        case XBOrderTicketTypePhone:
        {
            NSString *phone = [[self.book.payContact.mobile componentsSeparatedByString:@"-"] lastObject];
            
            self.book.payContact.mobile = [NSString stringWithFormat:@"%@-%@",[[self.book.payContact.mobile componentsSeparatedByString:@"-"] firstObject],text];
            
            
            if ([phone isEqualToString:text]) {
                
                self.verifityLabel.hidden = NO;
                
                self.textFieldRightConstraints.constant = self.xb_width - self.verifityLabel.xb_x;
                
            } else {
                
                self.verifityLabel.hidden = YES;
                
                self.textFieldRightConstraints.constant = 10.;
            }

        }
            break;
    }

    
    return YES;
}

- (IBAction)pullAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderTicketCell:didSelectCountryCodeWithBook:)]) {
        
        [self.delegate orderTicketCell:self didSelectCountryCodeWithBook:self.book];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}



@end
