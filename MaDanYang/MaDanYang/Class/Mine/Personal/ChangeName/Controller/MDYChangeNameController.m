//
//  MDYChangeNameController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYChangeNameController.h"
#import "MDYUploadUserRequest.h"
@interface MDYChangeNameController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation MDYChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self craeteView];
}
- (void)craeteView {
    UILabel *titlelabel = [[UILabel alloc] init];
    [self.view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).insets(UIEdgeInsetsMake(16, 16, 0, 0));
    }];
    [titlelabel setTextColor:K_TextBlackColor];
    [titlelabel setFont:KBoldFont(20)];
    [titlelabel setText:@"修改昵称"];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_equalTo(16);
        make.top.equalTo(titlelabel.mas_bottom).mas_offset(40);
        make.right.lessThanOrEqualTo(self.view.mas_right).mas_offset(-12);
    }];
    [nameLabel setTextColor:K_TextBlackColor];
    [nameLabel setFont:KSystemFont(16)];
    [nameLabel setText:[NSString stringWithFormat:@"当前昵称：%@",kUser.nickname]];
    
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).mas_offset(8);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(52);
    }];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入昵称" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KSystemFont(14)
        }];
    textField.attributedPlaceholder = attrString;
    [textField setTextColor:K_TextBlackColor];
    self.textField = textField;
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textField).insets(UIEdgeInsetsZero);
        make.top.equalTo(textField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [lineView setBackgroundColor:K_SeparatorColor];
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(49);
        make.top.equalTo(lineView.mas_bottom).mas_offset(66);
    }];
    [button setTitle:@"提交" forState:UIControlStateNormal];
}
- (void)pushButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self uploadName];
}
#pragma mark - Networking
- (void)uploadName {
    MDYUploadUserRequest *request = [MDYUploadUserRequest new];
    request.nickname = self.textField.text;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            
            MDYUserModel *model = kUser;
            model.nickname = weakSelf.textField.text;
            [MDYSingleCache shareSingleCache].userModel = model;
            
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
@end
