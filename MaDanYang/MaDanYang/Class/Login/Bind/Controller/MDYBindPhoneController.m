//
//  MDYBindPhoneController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/3.
//

#import "MDYBindPhoneController.h"
#import "MDYSendCode.h"
#import "MDYBindPhone.h"
#import "MDYLoginAgreement.h"
#import "MDYPrivacyAgreement.h"
#import "AppDelegate+CKAppDelegate.h"
#import "MDYUserInfoRequest.h"
@interface MDYBindPhoneController (){
    NSInteger _timeOut;
}
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign, getter=isAgree) BOOL agree;
@end

@implementation MDYBindPhoneController
static CGFloat const contentHeight = 690.0f;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - IBAction
- (void)selectedButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.agree = sender.isSelected;
}
- (void)userAgreeButtonAction:(UIButton *)sender {
    
    MDYLoginAgreement *request = [MDYLoginAgreement new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYLoginAgreementModel *model = response.data;
        CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"详情"];
        vc.htmlString = model.txt;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
- (void)userPrivacyButtonAction:(UIButton *)sender {
    MDYPrivacyAgreement *request = [MDYPrivacyAgreement new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYLoginAgreementModel *model = response.data;
        CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"详情"];
        vc.htmlString = model.txt;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
- (void)loginButtonAction:(UIButton *)sender {
    if (self.phoneText.text.length <= 0) {
        [MBProgressHUD showMessage:@"请输入手机号"];
        return;
    }
    if (self.codeText.text.length <= 0) {
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    if (!self.isAgree) {
        [MBProgressHUD showMessage:@"请同意用户协议"];
        return;
    }
    MDYBindPhone *request = [MDYBindPhone new];
    request.openid = [[NSUserDefaults standardUserDefaults] objectForKey:MDYWechatOpenIDKey];
    request.phone = self.phoneText.text;
    request.code = self.codeText.text;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        
        if (response.code != 0) {
            weakSelf.codeText.text = @"";
            return;
        }
        MDYBindPhoneModel *model = response.data;
        [MDYSingleCache shareSingleCache].token = model.token;
        [weakSelf getUserInfo];
        
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [MBProgressHUD showMessage:response.message];
    }];
}
- (void)getUserInfo {
    MDYUserInfoRequest *request = [MDYUserInfoRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code != 0) {
            return;
        }
        MDYUserModel *model = response.data;
        [MDYSingleCache shareSingleCache].userModel = model;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [weakSelf animation];
        [delegate setRootViewControllerWithLogin:YES];
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
#pragma mark - UI
- (void)createUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [scrollView setContentSize:CGSizeMake(0, contentHeight)];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    [scrollView addSubview:backImageView];
    [backImageView setFrame:CGRectMake(0, 0, CK_WIDTH, contentHeight)];
    [backImageView setContentMode:UIViewContentModeScaleAspectFill];
    [backImageView setImage:[UIImage imageNamed:@"login_background"]];
    [backImageView setUserInteractionEnabled:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [backImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).mas_offset(16);
        make.top.equalTo(backImageView.mas_top).mas_offset(20);
    }];
    [titleLabel setText:@"绑定手机号"];
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:KBoldFont(20)];
    [titleLabel setTextColor:K_TextBlackColor];
    
    UILabel *userLabel = [[UILabel alloc] init];
    [backImageView addSubview:userLabel];
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).mas_offset(16);
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(40);
    }];
    [userLabel setText:@"手机号"];
    [userLabel setFont:KSystemFont(16)];
    [userLabel setTextColor:K_TextBlackColor];
    
    UITextField *userTextField = [[UITextField alloc] init];
    [backImageView addSubview:userTextField];
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLabel.mas_bottom);
        make.left.right.equalTo(backImageView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(52);
    }];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入账号" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KSystemFont(14)
        }];
    [userTextField setTextColor:K_TextBlackColor];
    userTextField.attributedPlaceholder = attrString;
    [userTextField setKeyboardType:UIKeyboardTypePhonePad];
    self.phoneText = userTextField;
    UIView *userLineView = [[UIView alloc] init];
    [backImageView addSubview:userLineView];
    [userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(userTextField).insets(UIEdgeInsetsZero);
        make.top.equalTo(userTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [userLineView setBackgroundColor:K_SeparatorColor];
    
    
    UILabel *passLabel = [[UILabel alloc] init];
    [backImageView addSubview:passLabel];
    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).mas_offset(16);
        make.top.equalTo(userTextField.mas_bottom).mas_offset(24);
    }];
    [passLabel setText:@"验证码"];
    [passLabel setFont:KSystemFont(16)];
    [passLabel setTextColor:K_TextBlackColor];
    
    UITextField *passTextField = [[UITextField alloc] init];
    [backImageView addSubview:passTextField];
    [passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passLabel.mas_bottom);
        make.left.right.equalTo(backImageView).insets(UIEdgeInsetsMake(0, 16, 0, 86));
        make.height.mas_equalTo(52);
    }];
    NSAttributedString *passAttrString = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KSystemFont(14)
        }];
    [passTextField setTextColor:K_TextBlackColor];
    passTextField.attributedPlaceholder = passAttrString;
    self.codeText = passTextField;
    
    UIButton *codeButton = [UIButton k_buttonWithTarget:self action:@selector(codeButtonAction:)];
    [backImageView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).mas_offset(-16);
        make.centerY.equalTo(passTextField.mas_centerY);
    }];
    [codeButton setTitleColor:KHexColor(0x2D82E5FF) forState:UIControlStateNormal];
    [codeButton setTitleColor:K_TextLightGrayColor forState:UIControlStateDisabled];
    [codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeButton.titleLabel setFont:KSystemFont(14)];
    self.codeButton = codeButton;
    
    UIView *codeLineView = [[UIView alloc] init];
    [backImageView addSubview:codeLineView];
    [codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backImageView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.top.equalTo(passTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [codeLineView setBackgroundColor:K_SeparatorColor];
    
    UIButton *selectedButton = [UIButton k_buttonWithTarget:self action:@selector(selectedButtonAction:)];
    [backImageView addSubview:selectedButton];
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).mas_offset(16);
        make.top.equalTo(passTextField.mas_bottom).mas_offset(40);
        make.width.height.mas_equalTo(14);
    }];
    [selectedButton setImage:[UIImage imageNamed:@"agree_normal"] forState:UIControlStateNormal];
    [selectedButton setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateSelected];
    
    UILabel *agreeLabel = [[UILabel alloc] init];
    [backImageView addSubview:agreeLabel];
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectedButton.mas_right).mas_offset(8);
        make.centerY.equalTo(selectedButton.mas_centerY);
    }];
    [agreeLabel setText:@"我同意"];
    [agreeLabel setTextColor:K_TextBlackColor];
    [agreeLabel setFont:KSystemFont(12)];
    
    UIButton *userAgreeButton = [UIButton k_buttonWithTarget:self action:@selector(userAgreeButtonAction:)];
    [backImageView addSubview:userAgreeButton];
    [userAgreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeLabel.mas_right);
        make.centerY.equalTo(selectedButton.mas_centerY);
    }];
    [userAgreeButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [userAgreeButton setTitleColor:KHexColor(0x2D82E5FF) forState:UIControlStateNormal];
    [userAgreeButton.titleLabel setFont:KSystemFont(12)];
    
    UILabel *andLabel = [[UILabel alloc] init];
    [backImageView addSubview:andLabel];
    [andLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userAgreeButton.mas_right);
        make.centerY.equalTo(selectedButton.mas_centerY);
    }];
    [andLabel setText:@"和"];
    [andLabel setTextColor:K_TextBlackColor];
    [andLabel setFont:KSystemFont(12)];
    
    UIButton *userPrivacyButton = [UIButton k_buttonWithTarget:self action:@selector(userPrivacyButtonAction:)];
    [backImageView addSubview:userPrivacyButton];
    [userPrivacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(andLabel.mas_right);
        make.centerY.equalTo(selectedButton.mas_centerY);
    }];
    [userPrivacyButton setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [userPrivacyButton setTitleColor:KHexColor(0x2D82E5FF) forState:UIControlStateNormal];
    [userPrivacyButton.titleLabel setFont:KSystemFont(12)];
    
    UIButton *loginButton = [UIButton k_mainButtonWithTarget:self action:@selector(loginButtonAction:)];
    [backImageView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectedButton.mas_bottom).mas_offset(139);
        make.left.right.equalTo(backImageView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(44);
    }];
    [loginButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    
}

@end
