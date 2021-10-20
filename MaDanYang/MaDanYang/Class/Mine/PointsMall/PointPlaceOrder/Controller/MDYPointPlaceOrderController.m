//
//  MDYPointPlaceOrderController.m
//  MaDanYang
//
//  Created by kckj on 2021/8/7.
//

#import "MDYPointPlaceOrderController.h"
#import "MDYMyAddressController.h"
#import "MDYOrderAddressTableCell.h"
#import "MDYOrderPayTypeTableCell.h"
#import "MDYOfflineAccountTableCell.h"
#import "MDYToPayGoodsTableCell.h"
#import "MDYIntergralOrderRequest.h"
#import "MDYIntegralOrderPayRequest.h"
@interface MDYPointPlaceOrderController ()<UITableViewDelegate,UITableViewDataSource,MDYMyaddressDeleaget>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *totelLabel;
@property (nonatomic, strong) MDYIntergralOrderModel *orderModel;

@end

@implementation MDYPointPlaceOrderController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"确认订单";
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadGoodsOrder];
    }];
    [self.tableView.mj_header beginRefreshing];
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
#pragma mark -
- (void)wechatPaySuccess {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toAddressView {
    MDYMyAddressController *vc = [[MDYMyAddressController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
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
#pragma mark - Networking
- (void)reloadGoodsOrder {
    
    NSString *addressId = @"";
    if (self.orderModel.address.address_id.length > 0) {
        addressId = self.orderModel.address.address_id;
    }
    NSString *numString = @"1";
    MDYIntergralOrderGoodsModel *goodsModel = self.orderModel.goods[0];
    if (goodsModel) {
        numString = goodsModel.goods_num;
    }
    MDYIntergralOrderRequest *request = [MDYIntergralOrderRequest new];
    request.goods_id = self.goodId;
    request.goods_num = numString;
    request.address_id = addressId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == 0) {
            MDYIntergralOrderModel *model = response.data;
            weakSelf.orderModel = model;
            [weakSelf.totelLabel setText:[NSString stringWithFormat:@"合计：%@积分",model.pay_price]];
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == -2) {
            [weakSelf noAddressAlter];
        }
    }];
}
- (void)submitOrder {
    
    NSString *numString = @"1";
    MDYIntergralOrderGoodsModel *goodsModel = self.orderModel.goods[0];
    if (goodsModel) {
        numString = goodsModel.goods_num;
    }
    NSString *addressId = @"";
    if (self.orderModel.address.address_id.length > 0) {
        addressId = self.orderModel.address.address_id;
    }
    MDYIntegralOrderPayRequest *request = [MDYIntegralOrderPayRequest new];
    request.goods_id = self.goodId;
    request.goods_num = numString;
    request.address_id = addressId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"兑换成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)pushButtonAction:(UIButton*)sender {
    [self submitOrder];
}
#pragma mark - MDYMyaddressDeleaget
- (void)didSelectedAddress:(NSDictionary *)data {
    MDYIntergralOrderAddressModel *model = [[MDYIntergralOrderAddressModel alloc] mj_setKeyValues:data];
    self.orderModel.address = model;
    [self reloadGoodsOrder];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            MDYOrderAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderAddressTableCell.class)];
            MDYIntergralOrderAddressModel *model = self.orderModel.address;
            [cell setIntegralAddressModel:model];
            return cell;
        }
        MDYToPayGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYToPayGoodsTableCell.class)];
        MDYIntergralOrderGoodsModel *model = self.orderModel.goods[indexPath.row];
        [cell setIntegralGoodModel:model];
        CKWeakify(self);
        [cell setDidChangeNum:^(NSInteger num) {
            MDYIntergralOrderGoodsModel *model = [weakSelf.orderModel.goods objectAtIndex:indexPath.row];
            model.goods_num = [NSString stringWithFormat:@"%ld",num];
            weakSelf.orderModel.goods = @[model];
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        return cell;
    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        MDYMyAddressController *vc = [[MDYMyAddressController alloc] init];
        vc.delegate =self;
        [self.navigationController pushViewController:vc animated:YES];
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
    }
    return _tableView;
}
- (MDYIntergralOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[MDYIntergralOrderModel alloc] init];
    }
    return _orderModel;
}
@end
