//
//  MDYSendMeesageView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import "MDYSendMeesageView.h"

@interface MDYSendMeesageView ()
@property (nonatomic, strong) UITextField *textfield;
@end

@implementation MDYSendMeesageView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        UIButton *shopButton = [UIButton k_buttonWithTarget:self action:@selector(shopButtonAction:)];
//        [self addSubview:shopButton];
//        [shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).mas_offset(16);
//            make.top.equalTo(self.mas_top).mas_offset(4);
//            make.width.mas_equalTo(50);
//        }];
//        [shopButton setImage:[UIImage imageNamed:@"shop_car_icon"] forState:UIControlStateNormal];
        
        UIButton *sendButton = [UIButton k_mainButtonWithTarget:self action:@selector(sendButtonAction:)];
        [self addSubview:sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-16);
            make.top.equalTo(self.mas_top).mas_offset(4);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(34);
        }];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        
        UITextField *textfield = [[UITextField alloc] init];
        [self addSubview:textfield];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_equalTo(12);
            make.right.equalTo(sendButton.mas_left).mas_offset(-12);
            make.height.mas_equalTo(34);
            make.top.equalTo(self.mas_top).mas_offset(4);
        }];
        [textfield setBackgroundColor:KHexColor(0xF5F5F5FF)];
        [textfield.layer setCornerRadius:17];
        [textfield setLeftViewMode:UITextFieldViewModeAlways];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 34)];
        [textfield setLeftView:leftView];
        self.textfield = textfield;
    }
    return self;
}
- (void)shopButtonAction:(UIButton *)sender {
    if (self.shopAction) {
        self.shopAction();
    }
}
- (void)sendButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.didSendAction) {
        self.didSendAction(self.textfield.text);
    }
    self.textfield.text = @"";
}
@end
