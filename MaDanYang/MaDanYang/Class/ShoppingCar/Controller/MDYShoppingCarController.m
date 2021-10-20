//
//  MDYShoppingCarController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/3.
//

#import "MDYShoppingCarController.h"
#import "MDYShoppingCarTableCell.h"
#import "MDYShopBottomView.h"
#import "MDYPlaceOrderController.h"
#import "MDYShoppingCarListRequest.h"
#import "MDYGoodsCarSelectedOrCancelReqeust.h"
#import "MDYGoodsSelectedAllRequest.h"
#import "MDYGoodsCarCancelAllRequest.h"
#import "MDYGoodsCarAddNumReqeust.h"
#import "MDYGoodsReduceNumRequest.h"
#import "MDYGoodsCarDeleteRequest.h"
@interface MDYShoppingCarController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MDYShopBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedData;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign, getter=isSelectedGoods) BOOL selectedGoods;
@end

@implementation MDYShoppingCarController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"购物车";
    self.selectedData = [NSMutableArray array];
    self.bottomView.hidden = YES;
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getListData];
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getListData];
    }];
}
- (void)getListData {
    MDYShoppingCarListRequest *request = [MDYShoppingCarListRequest new];
    request.page = self.pageNum;
    request.limit = 100;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (response.data) {
            if (weakSelf.pageNum == 1) {
                weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
                weakSelf.selectedData = [NSMutableArray array];
                weakSelf.bottomView.array = self.selectedData;
            } else {
                [weakSelf.dataSource addObjectsFromArray:response.data];
            }
        }
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        BOOL isAll = YES;
        CGFloat allMoney = 0;
        if (weakSelf.dataSource.count > 0) {
            for (MDYShoppingCarListModel *model in weakSelf.dataSource) {
                if ([model.is_default integerValue] != 1) {
                    isAll = NO;
                } else {
                    allMoney += [model.price floatValue] * [model.num integerValue];
                }
            }
        } else {
            isAll = NO;
        }
        weakSelf.selectedGoods = allMoney > 0;
        weakSelf.bottomView.allMoney = allMoney;
        weakSelf.bottomView.selectedAll = isAll;
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)cancelOrSelectedGoods:(NSString *)goodId {
    MDYGoodsCarSelectedOrCancelReqeust *request = [MDYGoodsCarSelectedOrCancelReqeust new];
    request.goods_car_id = goodId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYGoodsAllMoneyModel *model = response.data;
        weakSelf.bottomView.allMoney = model.choice_money;
        BOOL isAll = YES;
        NSInteger selectedGoods = 0;
        for (MDYShoppingCarListModel *model in weakSelf.dataSource) {
            if ([model.is_default integerValue] != 1) {
                isAll = NO;
            } else {
                selectedGoods++;
            }
        }
        weakSelf.selectedGoods = selectedGoods > 0;
        weakSelf.bottomView.selectedAll = isAll;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)goodsSelectedAll {
    MDYGoodsSelectedAllRequest *request = [MDYGoodsSelectedAllRequest new];
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYGoodsAllMoneyModel *model = response.data;
        weakSelf.bottomView.allMoney = model.choice_money;
        weakSelf.selectedGoods = model.choice_money > 0;
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)goodsCancelAll {
    MDYGoodsCarCancelAllRequest *request = [MDYGoodsCarCancelAllRequest new];
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYGoodsAllMoneyModel *model = response.data;
        weakSelf.bottomView.allMoney = model.choice_money;
        weakSelf.selectedGoods = NO;
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)addGoodsCarWithid:(NSString *)goodId {
    MDYGoodsCarAddNumReqeust *request = [MDYGoodsCarAddNumReqeust new];
    request.goods_car_id = goodId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        
        MDYGoodsCarAddNumModel *model = response.data;
        weakSelf.bottomView.allMoney = model.choice_money;
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)reduceGoodsCarWithid:(NSString *)goodId {
    MDYGoodsReduceNumRequest *request = [MDYGoodsReduceNumRequest new];
    request.goods_car_id = goodId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        MDYGoodsCarAddNumModel *model = response.data;
        weakSelf.bottomView.allMoney = model.choice_money;
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)deleteGoodsCarWithGoodsId:(NSString *)goodId index:(NSInteger)index {
    MDYGoodsCarDeleteRequest *request = [MDYGoodsCarDeleteRequest new];
    request.goods_car_id = goodId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYGoodsCarDeleteModel *model = response.data;
            weakSelf.bottomView.allMoney = model.choice_money;
            [weakSelf.dataSource removeObjectAtIndex:index];
            [weakSelf.tableView reloadData];
        }
        
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKWeakify(self);
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        MDYShoppingCarListModel *model = weakSelf.dataSource[indexPath.row];
        [weakSelf deleteGoodsCarWithGoodsId:model.goods_car_id index:indexPath.row];
    }];

    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 167;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYShoppingCarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYShoppingCarTableCell.class)];
    MDYShoppingCarListModel *model = self.dataSource[indexPath.row];
    [cell setListModel:model];
    CKWeakify(self);
    [cell setDidChangeNum:^(NSInteger num) {
        if (num > 0) {
            [weakSelf addGoodsCarWithid:model.goods_car_id];
        } else {
            [weakSelf reduceGoodsCarWithid:model.goods_car_id];
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDYShoppingCarListModel *model = self.dataSource[indexPath.row];
    model.is_default = [model.is_default integerValue] == 1 ? @"0":@"1";
    [self cancelOrSelectedGoods:model.goods_car_id];
    [tableView reloadData];
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"当前还没有商品";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (dataSource.count <= 0) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        CGFloat bottomHeight = self.isNoTabbar ? 49+34:49;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, bottomHeight, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 16)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYShoppingCarTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYShoppingCarTableCell.class)];
    }
    return _tableView;
}
- (MDYShopBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MDYShopBottomView alloc] init];
        [self.view addSubview:_bottomView];
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(49);
        }];
        CKWeakify(self);
        [_bottomView setToPayAction:^{
            if (!weakSelf.isSelectedGoods) {
                [MBProgressHUD showMessage:@"请选择商品"];
                return;
            }
            MDYPlaceOrderController *vc= [[MDYPlaceOrderController alloc] init];
            vc.shoppingCar = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [_bottomView setDidSelectedAll:^(BOOL isAll){
            if (isAll) {
                for (MDYShoppingCarListModel *model in weakSelf.dataSource) {
                    model.is_default = @"1";
                }
                [weakSelf goodsSelectedAll];
            } else {
                for (MDYShoppingCarListModel *model in weakSelf.dataSource) {
                    model.is_default = @"0";
                }
                [weakSelf goodsCancelAll];
            }
        }];
    }
    return _bottomView;
}
@end
