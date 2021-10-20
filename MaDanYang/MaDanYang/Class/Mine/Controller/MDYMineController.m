//
//  MDYMineController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/3.
//

#import "MDYMineController.h"
#import "MDYMineHeaderView.h"
#import "MDYDistributionListController.h"
#import "MDYMyPointsController.h"
#import "MDYPersonalController.h"
#import "MDYMianOrderController.h"
#import "MDYMyQuestionController.h"
#import "MDYMyCourseController.h"
#import "MDYMyAppointmentController.h"
#import "MDYMyAddressController.h"
#import "MDYAboutUsController.h"
#import "MDYScanQRController.h"
#import "AppDelegate+CKAppDelegate.h"
#import "MDYUserInfoRequest.h"
#import "MDYAboutUsRequest.h"
#import "MDYQRBangdingRequest.h"
#import "MDYUploadAppRequest.h"
@interface MDYMineController ()<UITableViewDelegate,UITableViewDataSource,MDYMineHeaderDelegate,MDYScanQRCodeDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MDYMineHeaderView *headerView;
@end

@implementation MDYMineController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KMediumFont(17),
        NSForegroundColorAttributeName : K_WhiteColor,
    };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    [self getUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@"我的收货地址",@"关于我们",@"版本更新",@"退出账号"];
    [self createView];
    [self headerView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getUserInfo];
    }];
    
}
- (void)createView {
    UIImageView *backImageView = [[UIImageView alloc] init];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [backImageView setImage:[UIImage imageNamed:@"home_top_back"]];
}
#pragma mark - Networking
- (void)getUserInfo {
    MDYUserInfoRequest *request = [MDYUserInfoRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code != 0) {
            return;
        }
        MDYUserModel *model = response.data;
        [MDYSingleCache shareSingleCache].userModel = model;
        [weakSelf.headerView setUserModel:model];
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)getAboutUs {
    MDYAboutUsRequest *request = [MDYAboutUsRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYAboutUsModel *model = response.data;
            CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] init];
            vc.navigationItem.title = @"关于我们";
            vc.htmlString = model.txt;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)checkUpload {
    MDYUploadAppRequest *request = [MDYUploadAppRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        MDYUploadAppModel *model = response.data;
        if ([app_Version floatValue] < [model.ios.version floatValue]) {
            [weakSelf showUploadViewWithUrl:model.ios.link title:model.ios.update];
        } else {
            [MBProgressHUD showMessage:@"当前为最新版本~"];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)showUploadViewWithUrl:(NSString *)urlStr title:(NSString *)title {
    CKWeakify(self);
    MDYUploadView *view = [[MDYUploadView alloc] init];
    [view.titleLabel setText:title];
    [view setDidToUpload:^{
//        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1329918420"; //更换id即可
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:0 completionHandler:nil];
        CKBaseWebViewController *vc = [CKBaseWebViewController new];
        vc.stringUrl = urlStr;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [view show];
}
#pragma mark - MDYMineHeaderDelegate
- (void)didClickScan {
    MDYScanQRController *vc = [[MDYScanQRController alloc] init];
    vc.delegate = self;
    CKNavigationController *nav = [[CKNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didClickChangeInfo {
    MDYPersonalController *vc = [[MDYPersonalController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didSelectedItemWithString:(NSString *)title {
    if ([title isEqualToString:@"我的分销"]) {
        MDYDistributionListController *vc = [[MDYDistributionListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"我的订单"]) {
        MDYMianOrderController *vc = [[MDYMianOrderController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"我的问答"]) {
        MDYMyQuestionController *vc = [[MDYMyQuestionController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"我的课程"]) {
        MDYMyCourseController *vc = [[MDYMyCourseController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"我的预约"]) {
        MDYMyAppointmentController *vc = [[MDYMyAppointmentController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didClickIntegral {
    MDYMyPointsController *vc = [[MDYMyPointsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MDYScanQRCodeDelegate
- (void)scanQRCodeFinish:(NSString *)valueString {
    CKWeakify(self);
    NSDictionary *dic = [valueString mj_JSONObject];
    if (!dic) {
        [MBProgressHUD showMessage:@"请扫描马丹阳分享二维码"];
        return;
    }
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
            MDYQRBangdingRequest *request = [MDYQRBangdingRequest new];
            request.u_id = dic[@"uid"];
            request.is_admin = dic[@"is_admin"] ? dic[@"is_admin"] : @"0";
            [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
                if (response.code == 0) {
                    [MBProgressHUD showSuccessfulWithMessage:@"绑定成功"];
                }
            } failHandler:^(MDYBaseResponse * _Nonnull response) {
                
            }];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *alterView = [[MMAlertView alloc] initWithTitle:@"" image:nil detail:[NSString stringWithFormat:@"您确认与 %@ 绑定关系？",dic[@"nickname"]] items:items];
    [alterView show];
    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textLabel setFont:KSystemFont(16)];
        [cell.textLabel setTextColor:K_TextBlackColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSString *string = [self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:string];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = [self.dataSource objectAtIndex:indexPath.row];
    if ([string isEqualToString:@"我的收货地址"]) {
        MDYMyAddressController *vc = [[MDYMyAddressController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([string isEqualToString:@"关于我们"]) {
        [self getAboutUs];
    } else if ([string isEqualToString:@"版本更新"]) {
        [self checkUpload];
    } else if ([string isEqualToString:@"退出账号"]) {
        [MDYSingleCache clean];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self animation];
        [delegate setRootViewControllerWithLogin:NO];
    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:self.headerView];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYShoppingCarTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYShoppingCarTableCell.class)];
    }
    return _tableView;
}
- (MDYMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MDYMineHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, 0, CK_WIDTH, 228);
        _headerView.dataSource = @[@{titleKey:@"我的订单",imageKey:@"mine_order_icon"},
                            @{titleKey:@"我的问答",imageKey:@"mine_q&a_icon"},
                            @{titleKey:@"我的课程",imageKey:@"mine_curriculum_icon"},
                            @{titleKey:@"我的预约",imageKey:@"mine_reserve_icon"},
                            @{titleKey:@"我的分销",imageKey:@"mine_distribution_icon"},
                            ];
    }
    return _headerView;
}
@end
