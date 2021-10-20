//
//  MDYPointOrderListController.m
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYPointOrderListController.h"
#import "MDYOrderListTableCell.h"
#import "MDYFillOrderNumberController.h"
#import "MDYLogisticsInfoController.h"
#import "MDYChangeGoodsController.h"
#import "MDYToPayController.h"
#import "MDYOrderDetailController.h"
#import "MDYIntegralOrderListRequest.h"
#import "MDYOrderConfirmReceiptRequest.h"
@interface MDYPointOrderListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MDYPointOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getOrderListData];
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getOrderListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)showCancelViewWithModel:(MDYIntegralOrderListModel *)model {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
//            [weakSelf cancelOrderWithOrderId:model.order_num];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *alterView = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
        [imageView setImage:[UIImage imageNamed:@"pay_alter_icon"]];
    } detail:@"您确认要取消付款么？" items:items];
    [alterView show];
}
#pragma mark - Networking
- (void)getOrderListData {
    MDYIntegralOrderListRequest *request = [MDYIntegralOrderListRequest new];
    request.page = 1;
    request.limit = 20;
    request.order_state = self.orderState;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)enterOrdersWithOrderId:(NSString *)orderId {
    MDYOrderConfirmReceiptRequest *request = [MDYOrderConfirmReceiptRequest new];
    request.order_num = orderId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 186;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderListTableCell.class)];
    MDYIntegralOrderListModel *model = self.dataSource[indexPath.row];
    [cell setIntegralModel:model];
    CKWeakify(self);
    [cell setDidClickButton:^(NSInteger index,MDYOrderType type) {
        if (index == 2) {
            if (type == MDYOrderTypeOfToReceived) {
                [weakSelf enterOrdersWithOrderId:model.order_num];
            }
        } else if (index == 1) {
            if (type == MDYOrderTypeOfToReceived) {
                MDYLogisticsInfoController *vc = [[MDYLogisticsInfoController alloc] init];
                vc.orderNum = model.order_num;
//                MDYOrderInfoGoodsModel *model = weakSelf.infoModel.order_goods[0];
//                vc.imageString = model.goods_img;
//                vc.nameString = model.goods_name;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MDYIntegralOrderListModel *model = self.dataSource[indexPath.row];
//    if ([model.type integerValue] == 2) {
//        return;
//    }
//    MDYOrderDetailController *vc = [[MDYOrderDetailController alloc] init];
//    vc.orderNum = model.order_num;
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"当前还没有订单数据";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.1)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderListTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderListTableCell.class)];
    }
    return _tableView;
}
@end
