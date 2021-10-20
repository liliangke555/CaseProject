//
//  MDYChangeResonTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYChangeResonTableCell.h"
@interface MDYChangeResonTableCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation MDYChangeResonTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        self.placeholder.hidden = YES;
    } else {
        self.placeholder.hidden = NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.didEndEditingString) {
        self.didEndEditingString(textView.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
