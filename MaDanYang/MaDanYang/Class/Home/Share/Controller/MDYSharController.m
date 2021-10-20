//
//  MDYSharController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MDYSharController.h"
#import "MDYGetQRCodeRequest.h"
#import <Photos/PHPhotoLibrary.h>
@interface MDYSharController ()
@property (nonatomic, strong) UIImageView *shareBackView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *myQrCodeImageView;
@property (nonatomic, strong) UIImageView *codeImageView;
@end

@implementation MDYSharController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分享有礼";
    [self createView];
    CKWeakify(self);
    self.scrollView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadQRCode];
    }];
    [self.scrollView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)reloadQRCode {
    MDYGetQRCodeRequest *request = [MDYGetQRCodeRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.scrollView.mj_header endRefreshing];
        if (response.code == 0) {
            MDYGetQRCodeModel *model = response.data;
            [weakSelf.myQrCodeImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            [weakSelf.codeImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.scrollView.mj_header endRefreshing];
    }];
}
- (void)createView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [scrollView setContentSize:CGSizeMake(0, 1228)];
    self.scrollView = scrollView;
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView setFrame:CGRectMake(0, 0, CK_WIDTH, 1228)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).mas_offset(16);
        make.top.equalTo(contentView.mas_top).mas_offset(24);
    }];
    [titleLabel setTextColor:K_TextBlackColor];
    [titleLabel setFont:KMediumFont(17)];
    [titleLabel setText:@"我的二维码"];
    
    UIView *view = [[UIView alloc] init];
    [contentView insertSubview:view atIndex:0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(titleLabel).insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(6);
    }];
    [view setBackgroundColor:K_MainColor];
    
    UIImageView *myCodeImageView = [[UIImageView alloc] init];
    [contentView addSubview:myCodeImageView];
    [myCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(32);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.height.mas_equalTo(186);
    }];
    [myCodeImageView setContentMode:UIViewContentModeScaleToFill];
    [myCodeImageView setImage:[UIImage imageNamed:@"my_code_icon"]];
    self.myQrCodeImageView = myCodeImageView;
    
    UIImageView *shareBckView = [[UIImageView alloc] init];
    [contentView addSubview:shareBckView];
    [shareBckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myCodeImageView.mas_bottom).mas_offset(32);
        make.left.right.bottom.equalTo(contentView).insets(UIEdgeInsetsZero);
    }];
    [shareBckView setContentMode:UIViewContentModeScaleToFill];
    [shareBckView setImage:[UIImage imageNamed:@"share_bottom_bg"]];
    self.shareBackView = shareBckView;
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [shareBckView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareBckView.mas_centerX);
            make.top.equalTo(shareBckView.mas_top).mas_offset(273);
        }];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setFont:KMediumFont(17)];
        [titleLabel setText:kUser.nickname];
        
        
        UIImageView *codeImageView = [[UIImageView alloc] init];
        [shareBckView addSubview:codeImageView];
        [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(24);
            make.centerX.equalTo(shareBckView.mas_centerX);
            make.width.height.mas_equalTo(142);
        }];
        [codeImageView setContentMode:UIViewContentModeScaleToFill];
        [codeImageView setImage:[UIImage imageNamed:@"my_code_icon"]];
        self.codeImageView = codeImageView;
        
        UILabel *noteLabel = [[UILabel alloc] init];
        [shareBckView addSubview:noteLabel];
        [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareBckView.mas_centerX);
            make.top.equalTo(codeImageView.mas_bottom).mas_offset(26);
        }];
        [noteLabel setTextColor:K_MainColor];
        [noteLabel setFont:KMediumFont(14)];
        [noteLabel setText:@"扫描二维码，加入我们"];
        
        UILabel *aboutLabel = [[UILabel alloc] init];
        [shareBckView addSubview:aboutLabel];
        [aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareBckView.mas_centerX);
            make.top.equalTo(noteLabel.mas_bottom).mas_offset(72);
        }];
        [aboutLabel setTextColor:K_WhiteColor];
        [aboutLabel setFont:KMediumFont(15)];
        [aboutLabel setText:@"关于APP"];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [shareBckView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareBckView.mas_centerX);
            make.top.equalTo(aboutLabel.mas_bottom).mas_offset(34);
            make.left.right.equalTo(shareBckView).insets(UIEdgeInsetsMake(0, 66, 0, 66));
        }];
        [detailLabel setTextColor:K_TextBlackColor];
        [detailLabel setFont:KMediumFont(15)];
        [detailLabel setNumberOfLines:0];
        [detailLabel setText:@"可以推荐用户下载APP，扫描这张二维码，即可绑定分享关系。他购物你就会得到相应的积分奖励哦~"];
        
    }
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(saveButtonAction:)];
    [contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).mas_offset(-100);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"保存到手机" forState:UIControlStateNormal];
}
- (void)saveButtonAction:(UIButton *)sender {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        __weak typeof(self)weakSelf = self;
        MMPopupItemHandler block = ^(NSInteger index){
                NSLog(@"clickd %@ button",@(index));
            if (index == 0) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        };
        NSArray *items =@[MMItemMake(@"我知道了", MMItemTypeNormal, block),
                          MMItemMake(@"设置", MMItemTypeHighlight, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"请在iPhone的“设置”-“隐私”-“相册”功能中，找到“马丹阳”打开相册访问权限"
                                                              items:items];
        [alertView show];
        return;
    }
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.shareBackView.bounds.size, self.shareBackView.opaque, 0.0);//opaque或者NO保证不失真
    {//重点
        [self.shareBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [MBProgressHUD showMessage:msg];
}
@end
