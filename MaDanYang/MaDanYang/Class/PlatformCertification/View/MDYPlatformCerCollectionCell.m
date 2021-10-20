//
//  MDYPlatformCerCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYPlatformCerCollectionCell.h"

@interface MDYPlatformCerCollectionCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;


@end

@implementation MDYPlatformCerCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)]];
    self.imageView.userInteractionEnabled = YES;
    
    [self.imageView.layer setCornerRadius:6];
    
    self.nameText.tag = 101;
    self.addressText.tag = 102;
    self.nameText.delegate = self;
    self.addressText.delegate = self;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 101) {
        if (self.didEndEditName) {
            self.didEndEditName(textField.text);
        }
    } else {
        if (self.didEndEditAddress) {
            self.didEndEditAddress(textField.text);
        }
    }
}
- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.didClickChangeType) {
        self.didClickChangeType();
    }
}
- (void)imageViewAction:(UITapGestureRecognizer *)sender {
    if (self.didClickSelectedImage) {
        self.didClickSelectedImage();
    }
}
- (void)setUserModel:(MDYUserModel *)userModel {
    _userModel = userModel;
    if (userModel) {
        
        if ([userModel.identity integerValue] != 0) {
            self.nameText.enabled = NO;
            self.addressText.enabled = NO;
            self.selectedButton.enabled = NO;
            self.imageView.userInteractionEnabled = NO;
        } else {
            self.nameText.enabled = YES;
            self.addressText.enabled = YES;
            self.selectedButton.enabled = YES;
            self.imageView.userInteractionEnabled = YES;
        }
        
        [self.nameText setText:userModel.enterprise_name];
        [self.addressText setText:userModel.enterprise_add];
        [self.selectedButton setTitle:userModel.enterprise_type forState:UIControlStateNormal];
        if (userModel.enterprise_img.length > 0) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:userModel.enterprise_img]];
            [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        } else {
            [self.imageView setImage:[UIImage imageNamed:@"upload_big_icon"]];
            [self.imageView setContentMode:UIViewContentModeScaleToFill];
        }
    }
}
@end
