//
//  MDYOrderListController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYOrderListController.h"
#import "MDYOrderListTableCell.h"
#import "MDYToPayController.h"
#import "MDYOrderDetailController.h"
#import "MDYLogisticsInfoController.h"
#import "MDYChangeGoodsController.h"
#import "MDYFillOrderNumberController.h"
#import "MDYMyOrderListRequest.h"
#import "MDYMyOrderCancelRequest.h"
#import "MDYOrderConfirmReceiptRequest.h"
#import "MDYOrderGroupListRequest.h"
#import "MDYGroupOrderDetailController.h"
@interface MDYOrderListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.dataSource = @[@"",@"",@"",@"",@"",@""];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        if (weakSelf.isGroupOrder) {
            [weakSelf reloadGroupList];
        } else {
            [weakSelf getListData];
        }
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.isGroupOrder) {
            [weakSelf reloadGroupList];
        } else {
            [weakSelf getListData];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRefreshList:) name:MDYOrderChangeGoodsSuccess object:nil];
}
- (void)didRefreshList:(NSNotification *)nofi {
    [self getListData];
}
#pragma mark -
- (void)showCancelViewWithModel:(MDYMyOrderListModel *)model {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
            [weakSelf cancelOrderWithOrderId:model.order_num];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *alterView = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
        [imageView setImage:[UIImage imageNamed:@"pay_alter_icon"]];
    } detail:@"您确实要取消付款么？" items:items];
    [alterView show];
}
#pragma mark - Networking
- (void)reloadGroupList {
    MDYOrderGroupListRequest *request = [MDYOrderGroupListRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (response.code == 0) {
            if (weakSelf.pageNum == 1) {
                weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
            } else {
                [weakSelf.dataSource addObjectsFromArray:response.data];
            }
            if (weakSelf.dataSource.count >= response.count) {
//                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                weakSelf.pageNum ++;
            }
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)getListData {
    MDYMyOrderListRequest *request = [MDYMyOrderListRequest new];
    request.page = self.pageNum;
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
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        NSMutableArray *mData = [weakSelf.dataSource mutableCopy];
        for (MDYMyOrderListModel *model in weakSelf.dataSource) {
            if ([model.type integerValue] == 2 && [model.state integerValue] > 1 && [model.pay_type integerValue] != 3) {
                [mData removeObject:model];
            }
        }
        weakSelf.dataSource = [mData mutableCopy];
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)cancelOrderWithOrderId:(NSString *)orderId {
    MDYMyOrderCancelRequest *request = [MDYMyOrderCancelRequest new];
    request.order_num = orderId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
//            MDYMyOrderCancelModel *model = response.data;
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
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
    MDYMyOrderListModel *model = self.dataSource[indexPath.row];
    cell.groupOrder = self.isGroupOrder;
    [cell setOrderModel:model];
    CKWeakify(self);
    [cell setDidClickButton:^(NSInteger index,MDYOrderType type) {
        if (index == 2) {
            if (type == MDYOrderTypeOfToPaid) {
                MDYToPayController *vc = [[MDYToPayController alloc] init];
                vc.orderNum = model.order_num;
                vc.type = model.type;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (type == MDYOrderTypeOfToFilledIn) {
                MDYFillOrderNumberController *vc = [[MDYFillOrderNumberController alloc] init];
                vc.orderNum = model.order_num;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (type == MDYOrderTypeOfToReceived) {
                [weakSelf enterOrdersWithOrderId:model.order_num];
            }
            if (type == MDYOrderTypeOfToDelivered) {
                [MBProgressHUD showSuccessfulWithMessage:@"催单成功，正在加急为您发货"];
            }
        } else if (index == 1) {
            if (type == MDYOrderTypeOfToPaid) {
                [weakSelf showCancelViewWithModel:model];
            }
            if (type == MDYOrderTypeOfToReceived) {
                MDYLogisticsInfoController *vc = [[MDYLogisticsInfoController alloc] init];
                vc.orderNum = model.order_num;
                vc.imageString = model.order_img;
                vc.nameString = model.order_name;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        } else {
            if (type == MDYOrderTypeOfToReceived) {
                MDYChangeGoodsController *vc = [[MDYChangeGoodsController alloc] init];
                vc.orderNum = model.order_num;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDYMyOrderListModel *model = self.dataSource[indexPath.row];
//    if (self.isGroupOrder) {
//        MDYGroupOrderDetailController *vc = [MDYGroupOrderDetailController new];
//        vc.orderNum = model.order_num;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    MDYOrderDetailController *vc = [[MDYOrderDetailController alloc] init];
    vc.orderNum = model.order_num;
    vc.groupOrder = model.order_type == 2;
    [self.navigationController pushViewController:vc animated:YES];
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
