//
//  MDYOrderDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYOrderDetailController.h"
#import "MDYOrderGoodsTableCell.h"
#import "MDYOrderAddressTableCell.h"
#import "MDYOrderIntegralTableCell.h"
#import "MDYOrderDetailButtonTableCell.h"
#import "MDYLogisticsInfoController.h"
#import "MDYChangeGoodsController.h"
#import "MDYOrderInfoReqeust.h"
#import "MDYGroupOrderDetailRequest.h"
#import "MDYGroupManDetailTableCell.h"
static NSString *const goodsKey = @"goodsKey";
static NSString *const groupKey = @"groupKey";
static NSString *const addressKey = @"addressKey";
static NSString *const integralKey = @"integralKey";
static NSString *const orderNumKey = @"订单号";
static NSString *const createTimeKey = @"创建时间";
static NSString *const payTimeKey = @"支付时间";
static NSString *const buttonKey = @"buttonKey";
@interface MDYOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MDYOrderInfoModel *infoModel;
@property (nonatomic, strong) UIButton *button;
@end

@implementation MDYOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isGroupOrder) {
        self.navigationItem.title = @"拼团中详情";
    } else {
        self.navigationItem.title = @"订单详情";
    }
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.isGroupOrder) {
            [weakSelf getGroupDetail];
            return;
        }
        [weakSelf getOrderDetail];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    if (self.orderType != 1 && self.orderType != 2) {
        return;
    }
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, KBottomSafeHeight + 10, 16));
        make.height.mas_equalTo(49);
    }];
    if (self.orderType == 1) {
        [button setTitle:@"申请换货" forState:UIControlStateNormal];
    }
    if (self.orderType == 2) {
        [button setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    self.button = button;
}
- (void)pushButtonAction:(UIButton *)sender {
    
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
        weakSelf.orderType = [weakSelf.infoModel.state integerValue];
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)getGroupDetail {
    MDYGroupOrderDetailRequest *request = [MDYGroupOrderDetailRequest new];
    request.order_num = self.orderNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.infoModel = response.data;
        weakSelf.orderType = [weakSelf.infoModel.state integerValue];
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *string = self.dataSource[section];
    if ([string isEqualToString:goodsKey]) {
        return self.infoModel.order_goods.count;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.dataSource[indexPath.section];
    if ([string isEqualToString:goodsKey]) {
        MDYOrderGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderGoodsTableCell.class)];
        MDYOrderInfoGoodsModel *model = self.infoModel.order_goods[indexPath.row];
        [cell setGoodsModel:model];
        return cell;
    }
    if ([string isEqualToString:groupKey]) {
        MDYGroupManDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGroupManDetailTableCell.class)];
        cell.manModels = self.infoModel.pintuanGroup;
        cell.num = self.infoModel.num;
        return cell;
    }
    if ([string isEqualToString:addressKey]) {
        MDYOrderAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderAddressTableCell.class)];
        [cell setInfoAddressModel:self.infoModel.address];
        return cell;
    }
    if ([string isEqualToString:integralKey]) {
        MDYOrderIntegralTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderIntegralTableCell.class)];
        [cell setIntegral:self.infoModel.integral];
        return cell;
    }
    if ([string isEqualToString:buttonKey]) {
        MDYOrderDetailButtonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderDetailButtonTableCell.class)];
        CKWeakify(self);
        [cell setDidClickButton:^(NSInteger index) {
            if (index == 0) {
                MDYChangeGoodsController *vc = [[MDYChangeGoodsController alloc] init];
                vc.orderNum = weakSelf.orderNum;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                MDYLogisticsInfoController *vc = [[MDYLogisticsInfoController alloc] init];
                vc.orderNum = weakSelf.orderNum;
                MDYOrderInfoGoodsModel *model = weakSelf.infoModel.order_goods[0];
                vc.imageString = model.goods_img;
                vc.nameString = model.goods_name;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell.textLabel setFont:KSystemFont(16)];
        [cell.textLabel setTextColor:K_TextBlackColor];
        [cell.detailTextLabel setTextColor:K_TextGrayColor];
        [cell.detailTextLabel setFont:KSystemFont(16)];
    }
    [cell.textLabel setText:string];
    if ([string isEqualToString:orderNumKey]) {
        [cell.detailTextLabel setText:self.orderNum];
    }
    if ([string isEqualToString:createTimeKey]) {
        [cell.detailTextLabel setText:self.infoModel.creation_time];
    }
    if ([string isEqualToString:payTimeKey]) {
        [cell.detailTextLabel setText:self.infoModel.pay_time];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"数据丢失了～";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - Setter
- (void)setOrderType:(MDYOrderType)orderType {
    _orderType = orderType;
    
    if (orderType == 0) {
        self.dataSource = [NSMutableArray arrayWithArray:@[goodsKey,
                                                           addressKey,
                                                           integralKey,
                                                           orderNumKey,
                                                           createTimeKey]];
        
    } else {
        if (orderType == 2) {
            self.dataSource = [NSMutableArray arrayWithArray:@[goodsKey,
                                                               addressKey,
                                                               integralKey,
                                                               orderNumKey,
                                                               createTimeKey,
                                                               payTimeKey,
                                                               buttonKey]];
        } else {
            self.dataSource = [NSMutableArray arrayWithArray:@[goodsKey,
                                                               addressKey,
                                                               integralKey,
                                                               orderNumKey,
                                                               createTimeKey,
                                                               payTimeKey]];
        }
    }
    if (self.isGroupOrder) {
        [self.dataSource insertObject:groupKey atIndex:1];
    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView setSectionHeaderHeight:0.01f];
        [_tableView setSectionFooterHeight:0.01f];
        CGFloat bottomHeight = 0;
        if (self.orderType == 1 || self.orderType == 2) {
            bottomHeight = 49 + 10 + KBottomSafeHeight;
        }
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, bottomHeight, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderGoodsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderGoodsTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderAddressTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderAddressTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderIntegralTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderIntegralTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderDetailButtonTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderDetailButtonTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGroupManDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGroupManDetailTableCell.class)];
    }
    return _tableView;
}
@end
