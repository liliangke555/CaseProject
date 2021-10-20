//
//  MDYCoursePayOfflineController.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYCoursePayOfflineController.h"
#import "MDYPayOfflineReqeust.h"
#import "MDYUploadImageRequest.h"
@interface MDYCoursePayOfflineController ()
@property (nonatomic, strong) UIImageView *photoImageView;
@end

@implementation MDYCoursePayOfflineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 1;
    self.navigationItem.title = @"提交汇款凭证";
    [self createView];
}
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)createView {
    
    UIButton *backButton = [UIButton k_buttonWithTarget:self action:@selector(backButtonAction:)];
    backButton.frame = CGRectMake(0, 0, 70, 40);
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:KSystemFont(16)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight +69, 0));
    }];
    [scrollView setContentSize:CGSizeMake(0, 485 + 1 * 156)];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    contentView.frame  = CGRectMake(0, 0, CK_WIDTH, 485 + 1 * 156);
    
    MASViewAttribute *lastAttribute = contentView.mas_top;
    
    MDYCurriculumDetailModel *model = self.orderModel.curriculum;
    
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [contentView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).mas_offset(24);
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.width.height.mas_equalTo(100);
    }];
    [headerImageView.layer setCornerRadius:6];
    [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [headerImageView setClipsToBounds:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).mas_offset(16);
        make.top.equalTo(headerImageView.mas_top);
        make.right.equalTo(contentView.mas_right).mas_offset(-16);
    }];
    [titleLabel setText:model.c_name];
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:KSystemFont(16)];
    [titleLabel setTextColor:K_TextBlackColor];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    [contentView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).mas_offset(16);
        make.bottom.equalTo(headerImageView.mas_bottom);
    }];
    [moneyLabel setText:[NSString stringWithFormat:@"实付：¥ %@",model.price]];
    [moneyLabel setFont:KMediumFont(14)];
    [moneyLabel setTextColor:K_TextMoneyColor];
    
    lastAttribute = headerImageView.mas_bottom;
    
    UIView *oneLineView = [[UIView alloc] init];
    [contentView addSubview:oneLineView];
    [oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.right.equalTo(contentView.mas_right).mas_offset(-16);
        make.top.equalTo(lastAttribute).mas_offset(32);
        make.height.mas_equalTo(0.5f);
    }];
    [oneLineView setBackgroundColor:K_SeparatorColor];
    
    UILabel *orderLabel = [[UILabel alloc] init];
    [contentView addSubview:orderLabel];
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.top.equalTo(oneLineView.mas_bottom).mas_offset(16);
    }];
    [orderLabel setText:@"订单号"];
    [orderLabel setFont:KSystemFont(16)];
    [orderLabel setTextColor:K_TextBlackColor];
    
    UILabel *orderDetailLabel = [[UILabel alloc] init];
    [contentView addSubview:orderDetailLabel];
    [orderDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).mas_offset(-16);
        make.centerY.equalTo(orderLabel.mas_centerY);
    }];
    [orderDetailLabel setText:self.orderNum];
    [orderDetailLabel setFont:KSystemFont(16)];
    [orderDetailLabel setTextColor:K_TextGrayColor];
    
    UIView *twoLineView = [[UIView alloc] init];
    [contentView addSubview:twoLineView];
    [twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.right.equalTo(contentView.mas_right).mas_offset(-16);
        make.top.equalTo(orderLabel.mas_bottom).mas_offset(16);
        make.height.mas_equalTo(0.5f);
    }];
    [twoLineView setBackgroundColor:K_SeparatorColor];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.top.equalTo(twoLineView.mas_bottom).mas_offset(16);
    }];
    [timeLabel setText:@"创建时间"];
    [timeLabel setFont:KSystemFont(16)];
    [timeLabel setTextColor:K_TextBlackColor];
    
    UILabel *timeDetailLabel = [[UILabel alloc] init];
    [contentView addSubview:timeDetailLabel];
    [timeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).mas_offset(-16);
        make.centerY.equalTo(timeLabel.mas_centerY);
    }];
    [timeDetailLabel setText:self.timeString];
    [timeDetailLabel setFont:KSystemFont(16)];
    [timeDetailLabel setTextColor:K_TextGrayColor];
    
    UIView *thereLineView = [[UIView alloc] init];
    [contentView addSubview:thereLineView];
    [thereLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.right.equalTo(contentView.mas_right).mas_offset(-16);
        make.top.equalTo(timeLabel.mas_bottom).mas_offset(16);
        make.height.mas_equalTo(0.5f);
    }];
    [thereLineView setBackgroundColor:K_SeparatorColor];
    
    lastAttribute = thereLineView.mas_bottom;
    {
        UIView *bankBgView = [[UIView alloc] init];
        [contentView addSubview:bankBgView];
        [bankBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(thereLineView.mas_bottom).mas_offset(32);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [bankBgView setBackgroundColor:K_WhiteColor];
        [bankBgView.layer setCornerRadius:6];
        [bankBgView.layer setShadowColor:K_ShadowColor.CGColor];
        [bankBgView.layer setShadowRadius:10.0f];
        [bankBgView.layer setShadowOffset:CGSizeMake(0, 2)];
        [bankBgView.layer setShadowOpacity:1.0f];
        [bankBgView setClipsToBounds:YES];
        bankBgView.layer.masksToBounds = NO;
        
    
        UILabel *titleLabel = [[UILabel alloc] init];
        [bankBgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankBgView.mas_left).mas_offset(12);
            make.top.equalTo(bankBgView.mas_top).mas_offset(16);
        }];
        [titleLabel setText:@"请您确认汇款信息"];
        [titleLabel setFont:KMediumFont(16)];
        [titleLabel setTextColor:KHexColor(0xF37575FF)];
        
        UILabel *accountNameLabel = [[UILabel alloc] init];
        [bankBgView addSubview:accountNameLabel];
        [accountNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_left);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(16);
        }];
        [accountNameLabel setText:[NSString stringWithFormat:@"户名：%@",self.orderModel.pay_offline.account_name]];
        [accountNameLabel setFont:KSystemFont(14)];
        [accountNameLabel setTextColor:K_TextBlackColor];
        
        UILabel *accountLabel = [[UILabel alloc] init];
        [bankBgView addSubview:accountLabel];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(accountNameLabel.mas_left);
            make.top.equalTo(accountNameLabel.mas_bottom).mas_offset(12);
        }];
        [accountLabel setText:[NSString stringWithFormat:@"账号：%@",self.orderModel.pay_offline.account]];
        [accountLabel setFont:KSystemFont(14)];
        [accountLabel setTextColor:K_TextBlackColor];
        
        UILabel *bankNameLabel = [[UILabel alloc] init];
        [bankBgView addSubview:bankNameLabel];
        [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(accountLabel.mas_left);
            make.top.equalTo(accountLabel.mas_bottom).mas_offset(12);
        }];
        [bankNameLabel setText:[NSString stringWithFormat:@"开户行：%@",self.orderModel.pay_offline.bank_of_deposit]];
        [bankNameLabel setFont:KSystemFont(14)];
        [bankNameLabel setTextColor:K_TextBlackColor];
        
        [bankBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bankNameLabel.mas_bottom).mas_offset(16);
        }];
        lastAttribute = bankBgView.mas_bottom;
    }
    
    UIImageView *addImageView = [[UIImageView alloc] init];
    [contentView addSubview:addImageView];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).mas_offset(24);
        make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(137);
    }];
    [addImageView setImage:[UIImage imageNamed:@"upload_big_icon"]];
    [addImageView setContentMode:UIViewContentModeScaleToFill];
    [addImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageAction:)]];
    self.photoImageView = addImageView;
    [addImageView setUserInteractionEnabled:YES];
    [addImageView.layer setCornerRadius:6];
    [addImageView setClipsToBounds:YES];
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, KBottomSafeHeight + 10, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"提交凭证" forState:UIControlStateNormal];
}
- (void)pushButtonAction:(UIButton *)sender {
    if (self.photoSource.count <= 0) {
        [MBProgressHUD showMessage:@"请选择需要上传的转账凭证"];
        return;
    }
    [self uploadImageWithImage:self.photoSource[0]];
}
- (void)addImageAction:(UITapGestureRecognizer *)sender {
    [self addImage];
}
- (void)refreshView {
    [self.photoImageView setImage:self.photoSource[0]];
}
#pragma mark  - Networking
- (void)uploadImageWithImage:(UIImage *)image {
    MDYUploadImageRequest *request = [MDYUploadImageRequest new];
    NSData *imageData;
    NSString *mimetype;
    if (UIImagePNGRepresentation(image) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(image);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    [MBProgressHUD showLoadingWithMessage:@"图片上传中..."];
    CKWeakify(self);
    request.hideLoadingView = YES;
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(MDYBaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUD];
        MDYUploadImageModel *model = response.data;
        [weakSelf uploadPayOfflineWithUrl:model.url];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUD];
    }];
}
- (void)uploadPayOfflineWithUrl:(NSString *)urlString {
    MDYPayOfflineReqeust *request = [MDYPayOfflineReqeust new];
    request.order_num = self.orderNum;
    request.offline_url = urlString;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"提交成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
@end
