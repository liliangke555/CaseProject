//
//  MDYInputInfoTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import "MDYInputInfoTableCell.h"

@interface MDYInputInfoTableCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *tectField;
@end

@implementation MDYInputInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tectField.delegate = self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.didEndEditingString) {
        self.didEndEditingString(textField.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
