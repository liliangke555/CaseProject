//
//  MDYChangePhoneController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYChangePhoneController.h"
#import "MDYSendCode.h"
#import "MDYUploadPhoneRequest.h"
@interface MDYChangePhoneController (){
    NSInteger _timeOut;
}
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MDYChangePhoneController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}
- (void)createView {
    UILabel *titlelabel = [[UILabel alloc] init];
    [self.view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).insets(UIEdgeInsetsMake(16, 16, 0, 0));
    }];
    [titlelabel setTextColor:K_TextBlackColor];
    [titlelabel setFont:KBoldFont(20)];
    [titlelabel setText:@"手机号修改"];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_equalTo(16);
        make.top.equalTo(titlelabel.mas_bottom).mas_offset(40);
    }];
    [phoneLabel setTextColor:K_TextBlackColor];
    [phoneLabel setFont:KSystemFont(16)];
    [phoneLabel setText:@"手机号"];
    
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).mas_offset(8);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(52);
    }];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KSystemFont(14)
        }];
    textField.attributedPlaceholder = attrString;
    [textField setTextColor:K_TextBlackColor];
    self.phoneText = textField;
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textField).insets(UIEdgeInsetsZero);
        make.top.equalTo(textField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [lineView setBackgroundColor:K_SeparatorColor];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    [self.view addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_equalTo(16);
        make.top.equalTo(lineView.mas_bottom).mas_offset(32);
    }];
    [codeLabel setTextColor:K_TextBlackColor];
    [codeLabel setFont:KSystemFont(16)];
    [codeLabel setText:@"验证码"];
    
    
    UITextField *codetextField = [[UITextField alloc] init];
    [self.view addSubview:codetextField];
    [codetextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom).mas_offset(8);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16 + 70 + 16));
        make.height.mas_equalTo(52);
    }];
    NSAttributedString *codeattrString = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KSystemFont(14)
        }];
    codetextField.attributedPlaceholder = codeattrString;
    [codetextField setTextColor:K_TextBlackColor];
    self.codeText = codetextField;
    
    UIButton *codeButton = [UIButton k_buttonWithTarget:self action:@selector(codeButtonAction:)];
    [self.view addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).mas_offset(-16);
        make.centerY.equalTo(codetextField.mas_centerY);
    }];
    [codeButton setTitleColor:KHexColor(0x2D82E5FF) forState:UIControlStateNormal];
    [codeButton setTitleColor:K_TextLightGrayColor forState:UIControlStateDisabled];
    [codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeButton.titleLabel setFont:KSystemFont(14)];
    self.codeButton = codeButton;
    
    UIView *codelineView = [[UIView alloc] init];
    [self.view addSubview:codelineView];
    [codelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codetextField.mas_left);
        make.right.equalTo(codeButton.mas_right);
        make.top.equalTo(codetextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [codelineView setBackgroundColor:K_SeparatorColor];
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(49);
        make.top.equalTo(codelineView.mas_bottom).mas_offset(56);
    }];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    
    UIButton *noButton = [UIButton k_buttonWithTarget:self action:@selector(noButtonAction:)];
    [self.view addSubview:noButton];
    [noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).mas_offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [noButton setTitleColor:KHexColor(0x2D82E5FF) forState:UIControlStateNormal];
    [noButton setTitleColor:K_TextLightGrayColor forState:UIControlStateDisabled];
    [noButton.titleLabel setFont:KSystemFont(12)];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"无法获取验证码?"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:titleRange];
    [noButton setAttributedTitle:title forState:UIControlStateNormal];
}
#pragma marK - IBAction
- (void)pushButtonAction:(UIButton *)sender {
    MDYUploadPhoneRequest *request = [MDYUploadPhoneRequest new];
    request.phone = self.phoneText.text;
    request.code = self.codeText.text;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYUserModel *model = kUser;
            model.phone = weakSelf.phoneText.text;
            [MDYSingleCache shareSingleCache].userModel = model;
            
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)codeButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    MDYSendCode *request = [MDYSendCode new];
    request.phone = self.phoneText.text;
    request.beizhu = @"登录";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [weakSelf startTimeoutWithButton:sender];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
- (void)startTimeoutWithButton:(UIButton *)sender {
    _timeOut = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    sender.enabled = NO;
    [sender setTitle:@"60s" forState:UIControlStateNormal];
}
- (void)timeOut:(NSTimer *)timer {
    _timeOut --;
    if(_timeOut == 0){
        [_timer invalidate];
        _timer = nil;
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%lds",_timeOut] forState:UIControlStateNormal];
    }
}
- (void)noButtonAction:(UIButton *)sender {
    
}
#pragma mark - Networking

@end
