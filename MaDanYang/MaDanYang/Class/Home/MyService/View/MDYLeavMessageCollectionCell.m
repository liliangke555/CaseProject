//
//  MDYLeavMessageCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYLeavMessageCollectionCell.h"

@interface MDYLeavMessageCollectionCell ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *botView;

@end

@implementation MDYLeavMessageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailText.delegate = self;
    self.nameText.delegate = self;
    self.nameText.tag = 1;
    self.phoneText.delegate = self;
    self.phoneText.tag = 2;
    
    [self.botView.layer setCornerRadius:3.5];
    [self.botView setClipsToBounds:YES];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"留言记录"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:titleRange];
    [self.recordButton setAttributedTitle:title forState:UIControlStateNormal];
}
- (IBAction)recordButtonAction:(UIButton *)sender {
    if (self.didClickRecord) {
        self.didClickRecord(self.botView);
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        if (self.didEditName) {
            self.didEditName(textField.text);
        }
    } else {
        if (self.didEditPhone) {
            self.didEditPhone(textField.text);
        }
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
    if (pointLength > 100) {
        [textView resignFirstResponder];
        [MBProgressHUD showMessage:@"内容不能大于100个字"];
        return NO;
    }
    [self.numLabel setText:[NSString stringWithFormat:@"%ld/100",pointLength]];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.didEditDetail) {
        self.didEditDetail(textView.text);
    }
}
@end
