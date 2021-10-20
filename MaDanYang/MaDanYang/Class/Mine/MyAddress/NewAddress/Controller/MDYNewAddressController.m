//
//  MDYNewAddressController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MDYNewAddressController.h"
#import "MDYAddressAddRequest.h"
#import "MDYMyAddressEditRequest.h"
@interface MDYNewAddressController ()<UITextFieldDelegate>
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, copy) NSString *regionString;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, assign, getter=isEditAddress) BOOL editAddress;
@end

@implementation MDYNewAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.listModel) {
        self.navigationItem.title = @"编辑地址";
        self.editAddress = YES;
    } else {
        self.navigationItem.title = @"新建地址";
        self.editAddress = NO;
    }
    [self createView];
}
#pragma mark - Networking
- (void)addAddressData {
    MDYAddressAddRequest *request = [MDYAddressAddRequest new];
    request.name = self.nameString;
    request.phone = self.phoneString;
    request.region = self.regionString;
    request.detailed_address = self.addressString;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)editAddress {
    MDYMyAddressEditRequest *request = [MDYMyAddressEditRequest new];
    request.address_id = self.listModel.address_id;
    request.name = self.nameString;
    request.phone = self.phoneString;
    request.region = self.regionString;
    request.detailed_address = self.addressString;
    request.is_default = self.listModel.is_default;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)createView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 69, 0));
    }];
    [scrollView setContentSize:CGSizeMake(0, 420)];
    
    UIView *contentView = [[UIImageView alloc] init];
    [scrollView addSubview:contentView];
    [contentView setFrame:CGRectMake(0, 0, CK_WIDTH, 420)];
    contentView.userInteractionEnabled = YES;
    MASViewAttribute *lastAttribute = contentView.mas_top;
    NSArray *titles = @[@"收货人",@"手机号",@"所在地区",@"详细地址"];
    NSInteger tag = 100;
    for (NSString *title in titles) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
        }];
        [titleLabel setText:title];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UITextField *textField = [[UITextField alloc] init];
        [contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(52);
        }];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入" attributes:
            @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                            NSFontAttributeName:KSystemFont(14)
            }];
        textField.attributedPlaceholder = attrString;
        [textField setTextColor:K_TextBlackColor];
        textField.tag = tag;
        textField.delegate = self;
        if (self.isEditAddress) {
            if (tag == 100) {
                [textField setText:self.listModel.name];
                self.nameString = self.listModel.name;
            }
            if (tag == 101) {
                [textField setText:self.listModel.phone];
                self.phoneString = self.listModel.phone;
            }
            if (tag == 102) {
                [textField setText:self.listModel.region];
                self.regionString = self.listModel.region;
            }
            if (tag == 103) {
                [textField setText:self.listModel.detailed_address];
                self.addressString = self.listModel.detailed_address;
            }
        }
        tag ++;
        
        UIView *userLineView = [[UIView alloc] init];
        [contentView addSubview:userLineView];
        [userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(textField).insets(UIEdgeInsetsZero);
            make.top.equalTo(textField.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        [userLineView setBackgroundColor:K_SeparatorColor];
        lastAttribute = userLineView.mas_bottom;
    }
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(saveButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 10 + KBottomSafeHeight, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"保存地址" forState:UIControlStateNormal];
}
- (void)saveButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    
    if (self.nameString.length <= 0) {
        [MBProgressHUD showMessage:@"请输入收货人姓名"];
        return;
    }
    if (self.phoneString.length <= 0) {
        [MBProgressHUD showMessage:@"请输入收货人手机号"];
        return;
    }
    if (self.regionString.length <= 0) {
        [MBProgressHUD showMessage:@"请输入所在地区"];
        return;
    }
    if (self.addressString.length <= 0) {
        [MBProgressHUD showMessage:@"请输入详细地址"];
        return;
    }
    if (self.isEditAddress) {
        [self editAddress];
        return;
    }
    [self addAddressData];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        self.nameString = textField.text;
    }
    if (textField.tag == 101) {
        self.phoneString = textField.text;
    }
    if (textField.tag == 102) {
        self.regionString = textField.text;
    }
    if (textField.tag == 103) {
        self.addressString = textField.text;
    }
}
@end
