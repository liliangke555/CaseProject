//
//  MDYPersonalController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYPersonalController.h"
#import "MDYPersonalHeadTableCell.h"
#import "MDYChangeNameController.h"
#import "MDYChangePhoneController.h"
#import "MDYPlatformCerController.h"
#import "MDYBindWechatRequest.h"
#import <WechatOpenSDK/WXApi.h>
#import "MDYUploadUserRequest.h"
#import "MDYUploadImageRequest.h"
@interface MDYPersonalController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MDYPersonalController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KMediumFont(17),
        NSForegroundColorAttributeName : K_TextBlackColor,
    };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 1;
    self.navigationItem.title = @"个人信息";
    self.dataSource = @[@"头像",@"昵称",@"手机号",@"绑定微信号",@"我的认证"];
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, KBottomSafeHeight + 10, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"保存" forState:UIControlStateNormal];
}
- (void)pushButtonAction:(UIButton *)sender {
    [MBProgressHUD showSuccessfulWithMessage:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)wechatAction {
    //判断微信是否安装
    if([WXApi isWXAppInstalled]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginNotification:) name:MDYWechatLoginSuccess object:nil];
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"login_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        //唤起微信
        [WXApi sendReq:req completion:^(BOOL success) {
            if (success) {
                NSLog(@"-- 成功 --");
                [MBProgressHUD showMessage:@"唤起微信成功"];
            } else {
                NSLog(@"-- 失败 --");
                [MBProgressHUD showMessage:@"唤起微信失败"];
            }
        }];
    }else{
        [MBProgressHUD showMessage:@"未安装微信或微信版本过低"];
    }
}
- (void)wechatLoginNotification:(NSNotification *)noti {
    SendAuthResp *resp = noti.object;
    NSString *code = resp.code;
    [self getWechatInfoWithCode:code];
}
- (void)getWechatInfoWithCode:(NSString *)code {
    
    CKWeakify(self);
    [MDYBaseRequest wechatLoginGetOpenIDWithCode:code successBlock:^(NSDictionary * _Nullable result) {
        NSLog(@"--- %@ ---",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            [weakSelf bindWechatWithOpenId:result[@"openid"]];
        }
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}
- (void)refreshView {
    [self uploadImageWithImage:self.photoSource[0]];
}
#pragma mark - Networking
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
        [weakSelf uploadHeadImageWithUrl:model.url];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUD];
    }];
}
- (void)uploadHeadImageWithUrl:(NSString *)url {
    MDYUploadUserRequest *request = [MDYUploadUserRequest new];
    request.headimgurl = url;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYUserModel *model = kUser;
            model.headimgurl = url;
            [MDYSingleCache shareSingleCache].userModel = model;
            
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)bindWechatWithOpenId:(NSString *)openId {
    MDYBindWechatRequest *request = [MDYBindWechatRequest new];
    request.openid = openId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYUserModel *model = kUser;
            model.is_weixin = YES;
            [MDYSingleCache shareSingleCache].userModel = model;
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 82;
    }
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        MDYPersonalHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYPersonalHeadTableCell.class)];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:kUser.headimgurl]
                              placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell.textLabel setFont:KSystemFont(16)];
        [cell.textLabel setTextColor:K_TextBlackColor];
        [cell.detailTextLabel setFont:KSystemFont(16)];
        [cell.detailTextLabel setTextColor:K_TextGrayColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSString *string = [self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:string];
    if ([string isEqualToString:@"昵称"]) {
        [cell.detailTextLabel setText:kUser.nickname];
    } else if ([string isEqualToString:@"手机号"]) {
        NSString *string = kUser.phone;
        string = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [cell.detailTextLabel setText:string];
    } else if ([string isEqualToString:@"绑定微信号"]) {
        if (kUser.is_weixin) {
            [cell.detailTextLabel setText:@"已绑定"];
        } else {
            [cell.detailTextLabel setText:@"未绑定"];
        }
    } else if ([string isEqualToString:@"我的认证"]) {
        [cell.detailTextLabel setText:kUser.enterprise_name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        [self addImage];
        return;
    }
    NSString *string = [self.dataSource objectAtIndex:indexPath.row];
    if ([string isEqualToString:@"昵称"]) {
        MDYChangeNameController *vc = [[MDYChangeNameController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([string isEqualToString:@"手机号"]) {
        MDYChangePhoneController *vc = [[MDYChangePhoneController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([string isEqualToString:@"绑定微信号"]) {
        [self wechatAction];
    } else if ([string isEqualToString:@"我的认证"]) {
        MDYPlatformCerController *vc = [[MDYPlatformCerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49 + KBottomSafeHeight + 16, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 12)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYPersonalHeadTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYPersonalHeadTableCell.class)];
    }
    return _tableView;
}
@end
