//
//  MDYPlaceOrderController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/26.
//

#import "MDYPlaceOrderController.h"
#import "MDYToPayGoodsTableCell.h"
#import "MDYOrderAddressTableCell.h"
#import "MDYOrderPayTypeTableCell.h"
#import "MDYPayOfflineController.h"
#import "MDYMyAddressController.h"
#import "MDYOfflineAccountTableCell.h"
#import "MDYPlaceOrderRequest.h"
#import "MDYPayTools.h"
#import "MDYSumitOrderRequest.h"
#import "MDYAliPayRequest.h"
#import "MDYWechatPayRequest.h"
#import "MDYShoppingCarOrderRequest.h"
#import "MDYGoodsCarAddNumReqeust.h"
#import "MDYGoodsReduceNumRequest.h"
#import "MDYSumitCarOrderReqeust.h"
#import "MDYMyGroupGoodsGroupRequest.h"
#import "MDYMyGroupGoodsSumitOrderRequest.h"
#import "MDYCoursePreviewOrderRequest.h"
#import "MDYMianOrderController.h"
@interface MDYPlaceOrderController ()<UITableViewDelegate,UITableViewDataSource,MDYMyaddressDeleaget>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *payArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *goodsDataSource;

@property (nonatomic, strong) MDYPlaceOrderModel *orderModel;
//@property (nonatomic, strong) MDYShoppingOrderModel *shoppingOrderModel;
@property (nonatomic, strong) UILabel *totelLabel;

@end

@implementation MDYPlaceOrderController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"确认订单";
    self.payArray = @[@"支付宝",@"微信支付",@"线下转账"];
    self.goodsDataSource = [NSMutableArray array];
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshReqeust];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPaySuccess) name:MDYWechatPaySuccess object:nil];
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
    [titlelabel setText:@"合计：¥ 0.00"];
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
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
}
#pragma mark - Private
/// 微信支付成功
- (void)wechatPaySuccess {
    [self.navigationController popViewControllerAnimated:YES];
}
/// 无收货地址弹窗
- (void)noAddressAlter {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
            [weakSelf toAddressView];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *alterView = [[MMAlertView alloc] initWithTitle:@"温馨提示" detail:@"您还没有选择默认收货地址，请选择收货地址！" items:items];
    [alterView show];
}
/// 跳转地址界面
- (void)toAddressView {
    MDYMyAddressController *vc = [[MDYMyAddressController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Networking
/// 刷新接口
- (void)refreshReqeust {
    if (self.isShoppingCar) {
        [self getShoppingCarOrder];
    } else {
        if (self.addonGroupId.length > 0) {
            [self reloadGroupOrder];
        } else {
            [self loadData];
        }
    }
}
/// 普通订单预览接口
- (void)loadData {
    NSString *payType = @"1";
    if (self.selectedIndex == 1) {
        payType = @"2";
    } else if (self.selectedIndex == 2) {
        payType = @"3";
    }
    NSString *addressId = @"";
    if (self.orderModel.address.address_id.length > 0) {
        addressId = self.orderModel.address.address_id;
    }
    NSString *numString = @"1";
    MDYPlaceOrderGoodsModel *goodsModel = self.orderModel.goods[0];
    if (goodsModel) {
        numString = goodsModel.goods_num;
    }
    
    MDYPlaceOrderRequest *request = [MDYPlaceOrderRequest new];
    request.goods_id = self.goodsId;
    request.goods_num = numString;
    request.pay_type = payType;
    request.address_id = addressId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == 0) {
            MDYPlaceOrderModel *model = response.data;
            weakSelf.orderModel = model;
            [weakSelf.totelLabel setText:[NSString stringWithFormat:@"合计：¥ %@",model.pay_price]];
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == -2) {
            [weakSelf noAddressAlter];
        }
    }];
}
/// 拼团订单预览接口
- (void)reloadGroupOrder {
    NSString *payType = @"1";
    if (self.selectedIndex == 1) {
        payType = @"2";
    } else if (self.selectedIndex == 2) {
        payType = @"3";
    }
    NSString *addressId = @"";
    if (self.orderModel.address.address_id.length > 0) {
        addressId = self.orderModel.address.address_id;
    }
    NSString *numString = @"1";
    MDYPlaceOrderGoodsModel *goodsModel = self.orderModel.goods[0];
    if (goodsModel) {
        numString = goodsModel.goods_num;
    }
    MDYMyGroupGoodsGroupRequest *request = [MDYMyGroupGoodsGroupRequest new];
    request.a_id = self.addonGroupId;
    request.address_id = addressId;
    request.pay_type = payType;
    request.goods_num = numString;
    request.group_id = self.groupId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == 0) {
            MDYPlaceOrderModel *model = response.data;
            weakSelf.orderModel = model;
            [weakSelf.totelLabel setText:[NSString stringWithFormat:@"合计：¥ %@",model.pay_price]];
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == -2) {
            [weakSelf noAddressAlter];
        }
    }];
}
/// 提交普通订单接口
- (void)sumitOrder {
    NSString *payType = @"1";
    if (self.selectedIndex == 1) {
        payType = @"2";
    } else if (self.selectedIndex == 2) {
        payType = @"3";
    }
    MDYPlaceOrderGoodsModel *model = [self.orderModel.goods objectAtIndex:0];
    MDYSumitOrderRequest *request = [MDYSumitOrderRequest new];
    request.goods_id = self.goodsId;
    request.goods_num = model.goods_num;
    request.address_id = self.orderModel.address.address_id;
    request.pay_type = payType;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYSumitOrderModel *model = response.data;
        if (weakSelf.selectedIndex == 0) {
            [weakSelf toAlipayWithOrder:model.data];
        } else if (weakSelf.selectedIndex == 1) {
            [weakSelf toWechatPayWithOrderId:model.data];
        } else {
//            MDYPayOfflineController *vc = [[MDYPayOfflineController alloc] init];
//            vc.orderModel = weakSelf.orderModel;
//            vc.orderNum = model.data;
//            vc.orderTime = model.time;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            [MBProgressHUD showSuccessfulWithMessage:@"订单已生成"];
            MDYMianOrderController *vc = [MDYMianOrderController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 提交拼团订单接口
- (void)sumiteGroupOrder {
    NSString *payType = @"1";
    if (self.selectedIndex == 1) {
        payType = @"2";
    } else if (self.selectedIndex == 2) {
        payType = @"3";
    }
    MDYPlaceOrderGoodsModel *model = [self.orderModel.goods objectAtIndex:0];
    MDYMyGroupGoodsSumitOrderRequest *request = [MDYMyGroupGoodsSumitOrderRequest new];
    request.a_id = self.addonGroupId;
    request.goods_num = model.goods_num;
    request.address_id = self.orderModel.address.address_id;
    request.pay_type = payType;
    request.group_id = self.groupId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYMyGroupGoodsSumitOrderModel *model = response.data;
            if (weakSelf.selectedIndex == 0) {
                [weakSelf toAlipayWithOrder:model.data];
            } else if (weakSelf.selectedIndex == 1) {
                [weakSelf toWechatPayWithOrderId:model.data];
            } else {
//                MDYPayOfflineController *vc = [[MDYPayOfflineController alloc] init];
//                vc.orderModel = weakSelf.orderModel;
//                vc.orderNum = model.data;
//                vc.orderTime = model.time;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
                [MBProgressHUD showSuccessfulWithMessage:@"订单已生成"];
                MDYMianOrderController *vc = [MDYMianOrderController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
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
                    [weakSelf.navigationController popViewControllerAnimated:YES];
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
/// 购物车订单预览接口
- (void)getShoppingCarOrder {
    NSString *payType = @"1";
    if (self.selectedIndex == 1) {
        payType = @"2";
    } else if (self.selectedIndex == 2) {
        payType = @"3";
    }
    NSString *addressId = @"";
    if (self.orderModel.address.address_id.length > 0) {
        addressId = self.orderModel.address.address_id;
    }
    
    MDYShoppingCarOrderRequest *request = [MDYShoppingCarOrderRequest new];
    request.pay_type = payType;
    request.address_id = addressId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == 0) {
            MDYPlaceOrderModel *model = response.data;
            weakSelf.orderModel = model;
            [weakSelf.totelLabel setText:[NSString stringWithFormat:@"合计：¥ %@",model.pay_price]];
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == -2) {
            [weakSelf noAddressAlter];
        }
    }];
}
/// 提交购物车订单接口
- (void)sumitCarOrder {
    NSString *payType = @"1";
    if (self.selectedIndex == 1) {
        payType = @"2";
    } else if (self.selectedIndex == 2) {
        payType = @"3";
    }
    MDYSumitCarOrderReqeust *request = [MDYSumitCarOrderReqeust new];
    request.pay_type = payType;
    request.address_id = self.orderModel.address.address_id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYSumitOrderModel *model = response.data;
        if (weakSelf.selectedIndex == 0) {
            [weakSelf toAlipayWithOrder:model.data];
        } else if (weakSelf.selectedIndex == 1) {
            [weakSelf toWechatPayWithOrderId:model.data];
        } else {
            MDYPayOfflineController *vc = [[MDYPayOfflineController alloc] init];
            vc.orderModel = weakSelf.orderModel;
            vc.orderNum = model.data;
            vc.orderTime = model.time;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 购物车商品加添数量
/// @param goodId 商品ID
- (void)addGoodsCarWithid:(NSString *)goodId {
    MDYGoodsCarAddNumReqeust *request = [MDYGoodsCarAddNumReqeust new];
    request.goods_car_id = goodId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf getShoppingCarOrder];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 购物车商品减少数量
/// @param goodId 商品ID
- (void)reduceGoodsCarWithid:(NSString *)goodId {
    MDYGoodsReduceNumRequest *request = [MDYGoodsReduceNumRequest new];
    request.goods_car_id = goodId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf getShoppingCarOrder];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
/// 提交订单按钮事件
/// @param sender button
- (void)pushButtonAction:(UIButton*)sender {
    if (self.isShoppingCar) {
        [self sumitCarOrder];
    } else {
        if (self.addonGroupId.length > 0) {
            [self sumiteGroupOrder];
        } else {
            [self sumitOrder];
        }
    }
}
#pragma mark - MDYMyaddressDeleaget
- (void)didSelectedAddress:(NSDictionary *)data {
    MDYPlaceOrderAddressModel *model = [[MDYPlaceOrderAddressModel alloc] mj_setKeyValues:data];
    self.orderModel.address = model;
//    [self refreshReqeust];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
        return self.orderModel.goods.count + 1;
    } else {
        return self.selectedIndex == 2 ? self.payArray.count + 1 : self.payArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.orderModel.goods.count) {
            MDYOrderAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderAddressTableCell.class)];
            MDYPlaceOrderAddressModel *model = self.orderModel.address;
            [cell setAddressModel:model];
            return cell;
        }
        MDYToPayGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYToPayGoodsTableCell.class)];
        MDYPlaceOrderGoodsModel *model = self.orderModel.goods[indexPath.row];
        [cell setGoodsModel:model];
        CKWeakify(self);
        [cell setDidChangeNum:^(NSInteger num) {
            if (weakSelf.isShoppingCar) {
                if ([model.goods_num integerValue] > num) {
                    [weakSelf reduceGoodsCarWithid:model.goods_car_id];
                } else {
                    [weakSelf addGoodsCarWithid:model.goods_car_id];
                }
            } else {
                MDYPlaceOrderGoodsModel *model = [weakSelf.orderModel.goods objectAtIndex:indexPath.row];
                model.goods_num = [NSString stringWithFormat:@"%ld",num];
                weakSelf.orderModel.goods = @[model];
                [weakSelf refreshReqeust];
            }
        }];
        return cell;
    } else {
        if (self.payArray.count == indexPath.row) {
            MDYOfflineAccountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOfflineAccountTableCell.class)];
            MDYPlaceOrderPayOfflineModel *model = self.orderModel.pay_offline;
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
    if (indexPath.section == 1) {
        if (self.payArray.count == indexPath.row) {
            return;
        }
        self.selectedIndex = indexPath.row;
        [self refreshReqeust];
    } else {
        if (indexPath.row == 1) {
            MDYMyAddressController *vc = [[MDYMyAddressController alloc] init];
            vc.delegate =self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
- (MDYPlaceOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[MDYPlaceOrderModel alloc] init];
    }
    return _orderModel;
}
@end
