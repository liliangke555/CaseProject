//
//  MDYToPayController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import "MDYToPayController.h"
#import "MDYToPayGoodsTableCell.h"
#import "MDYOrderAddressTableCell.h"
#import "MDYOrderPayTypeTableCell.h"
#import "MDYOrderOfflinePayController.h"
#import "MDYMyAddressController.h"
#import "MDYOfflineAccountTableCell.h"
#import "MDYAliPayRequest.h"
#import "MDYPayTools.h"
#import "MDYWechatPayRequest.h"
@interface MDYToPayController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *payArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UILabel *totelLabel;

@property (nonatomic, strong) MDYOrderInfoModel *infoModel;
@property (nonatomic, strong) NSArray *orderGoods;
@end

@implementation MDYToPayController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"立即付款";
    self.payArray = @[@"支付宝",@"微信支付",@"线下转账"];
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getOrderDetail];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPaySuccess) name:MDYWechatPaySuccess object:nil];
}
#pragma mark - Private
/// 微信支付成功
- (void)wechatPaySuccess {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView {
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    UIView *line = [[UIView alloc] init];
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(bottomView).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(0.5f);
    }];
    [line setBackgroundColor:K_SeparatorColor];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [bottomView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(bottomView).insets(UIEdgeInsetsMake(14, 16, 0, 0));
    }];
    [titlelabel setTextColor:K_TextMoneyColor];
    [titlelabel setFont:KMediumFont(16)];
    [titlelabel setText:@"合计：¥ 00.00"];
    self.totelLabel = titlelabel;
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titlelabel.mas_centerY);
        make.right.equalTo(bottomView.mas_right).mas_offset(-16);
        make.width.mas_equalTo(147);
        make.height.mas_equalTo(40);
    }];
    UIImage *img = [UIImage ck_imageWithColor:KHexColor(0xF37575FF)];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setTitle:@"立即付款" forState:UIControlStateNormal];
}
#pragma mark - Networking
- (void)getOrderDetail {
    MDYOrderInfoReqeust *request = [MDYOrderInfoReqeust new];
    request.order_num = self.orderNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.infoModel = response.data;
        weakSelf.orderGoods = weakSelf.infoModel.order_goods;
        weakSelf.selectedIndex = [weakSelf.infoModel.pay_type integerValue] - 1;
        [weakSelf.totelLabel setText:[NSString stringWithFormat:@"合计：¥ %@",weakSelf.infoModel.pay_price]];
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
/// 拉起支付宝支付接口
/// @param orderId 订单号
- (void)toAlipayWithOrder:(NSString *)orderId {
    MDYAliPayRequest *request = [MDYAliPayRequest new];
    request.order_num = orderId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYAliPayModel *model = response.data;
            [MDYPayTools  kcPayWithZFBStringSigned:model.data completion:^(NSDictionary * _Nonnull resultDic) {
                if ([resultDic[@"resultStatus"] intValue] == 9000) {
                    [MBProgressHUD showSuccessfulWithMessage:@"支付成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showMessage:@"支付失败"];
                }
            }];
        }
        
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 拉起微信支付
/// @param orderId 订单号
- (void)toWechatPayWithOrderId:(NSString *)orderId {
    MDYWechatPayRequest *request = [MDYWechatPayRequest new];
    request.order_num = orderId;
//    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYWechatPayModel *model = response.data;
            [MDYPayTools kcPayWithWXDicData:model.mj_keyValues completion:^(BOOL success) {
                NSLog(@"%d",success);
            }];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)pushButtonAction:(UIButton*)sender {
    if (self.selectedIndex == 2) {
        MDYOrderOfflinePayController *vc = [[MDYOrderOfflinePayController alloc] init];
        vc.orderNum = self.orderNum;
        vc.orderTime = self.infoModel.creation_time;
        vc.orderModel = self.infoModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.selectedIndex == 0) {
        [self toAlipayWithOrder:self.orderNum];
    } else {
        [self toWechatPayWithOrderId:self.orderNum];
    }
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 30)];
        UILabel *titleLabel = [[UILabel alloc] init];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).mas_offset(16);
            make.centerY.equalTo(view.mas_centerY);
        }];
        [titleLabel setText:@"支付方式"];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setFont:KMediumFont(17)];
        
        UIView *Lineview = [[UIView alloc] init];
        [view insertSubview:Lineview atIndex:0];
        [Lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(titleLabel).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(6);
        }];
        [Lineview setBackgroundColor:K_MainColor];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return ([self.type integerValue] == 1) ? self.orderGoods.count + 1 : self.orderGoods.count;
    } else {
        return self.selectedIndex == 2 ? self.payArray.count + 1 : self.payArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.orderGoods.count) {
            MDYOrderAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderAddressTableCell.class)];
            MDYPlaceOrderAddressModel *addressModel = [MDYPlaceOrderAddressModel mj_objectWithKeyValues:[self.infoModel.address mj_keyValues]];
            [cell setAddressModel:addressModel];
            return cell;
        }
        MDYToPayGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYToPayGoodsTableCell.class)];
        MDYOrderInfoGoodsModel *model = self.orderGoods[indexPath.row];
        [cell setOrderGoodsModel:model];
        return cell;
    } else {
        if (self.payArray.count == indexPath.row) {
            MDYOfflineAccountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOfflineAccountTableCell.class)];
            MDYPlaceOrderPayOfflineModel *model = self.infoModel.pay_offline;
            [cell setOfflineModel:model];
            return cell;
        }
        MDYOrderPayTypeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderPayTypeTableCell.class)];
        cell.title = self.payArray[indexPath.row];
        cell.select = indexPath.row == self.selectedIndex;
        return cell;
    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        self.selectedIndex = indexPath.row;
//        [tableView reloadData];
//    } else {
//        if (indexPath.row == 1) {
//            MDYMyAddressController *vc = [[MDYMyAddressController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49 + 10 + KBottomSafeHeight, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYToPayGoodsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYToPayGoodsTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderAddressTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderAddressTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderPayTypeTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderPayTypeTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOfflineAccountTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOfflineAccountTableCell.class)];
    }
    return _tableView;
}
@end
