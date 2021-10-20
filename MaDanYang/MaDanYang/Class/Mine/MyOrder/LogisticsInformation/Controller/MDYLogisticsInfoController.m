//
//  MDYLogisticsInfoController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYLogisticsInfoController.h"
#import "MDYLogisticsGodsTableCell.h"
#import "MDYLogisticsCompanyTableCell.h"
#import "MDYLogisticsDetailTableCell.h"
#import "MDYOrderSynquerysRequest.h"
#import "MDYOrderInfoReqeust.h"
@interface MDYLogisticsInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) MDYOrderSynquerysModel *infoModel;
@property (nonatomic, strong) MDYOrderInfoModel *orderInfoModel;
@property (nonatomic, strong) NSArray *orderGoods;

@end

@implementation MDYLogisticsInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    self.navigationItem.title = @"物流信息";
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        
        dispatch_group_t _group = dispatch_group_create();
        [weakSelf reloadDetailWithGroup:_group];
        [weakSelf getOrderDetailWithGroup:_group];
        
        dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)reloadDetailWithGroup:(dispatch_group_t)_group {
    MDYOrderSynquerysRequest *request = [MDYOrderSynquerysRequest new];
    request.order_num = self.orderNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(_group);
        if (response.code == 0) {
            weakSelf.infoModel = response.data;
            weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.infoModel.data];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(_group);
    }];
}
- (void)getOrderDetailWithGroup:(dispatch_group_t)_group {
    MDYOrderInfoReqeust *request = [MDYOrderInfoReqeust new];
    request.order_num = self.orderNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(_group);
        weakSelf.orderInfoModel = response.data;
        weakSelf.orderGoods = weakSelf.orderInfoModel.order_goods;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(_group);
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.orderGoods.count;
    }
    return self.dataSource.count + 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 10)];
        [view setBackgroundColor:KHexColor(0xF5F5F5FF)];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0.0001f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MDYLogisticsGodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYLogisticsGodsTableCell.class)];
        MDYOrderInfoGoodsModel *model = self.orderGoods[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
        [cell.titleLabel setText:model.goods_name];
        return cell;
    } else {
        if (indexPath.row == 0) {
            MDYLogisticsCompanyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYLogisticsCompanyTableCell.class)];
            [cell setInfoModel:self.infoModel];
            return cell;
        } else {
            MDYLogisticsDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYLogisticsDetailTableCell.class)];
            MDYOrderSynquerysRouteModel *model = self.dataSource[indexPath.row - 1];
//            NSString *string = [self.dataSource objectAtIndex:indexPath.row - 1];
//            cell.title = string;
            [cell setRouteModel:model];
            if (self.dataSource.count == indexPath.row) {
                cell.line.hidden = YES;
            } else {
                cell.line.hidden = NO;
            }
            if (indexPath.row == 1) {
                cell.topLine.hidden = YES;
            } else {
                cell.topLine.hidden = NO;
            }
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:[UIColor clearColor]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYLogisticsGodsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYLogisticsGodsTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYLogisticsCompanyTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYLogisticsCompanyTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYLogisticsDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYLogisticsDetailTableCell.class)];
    }
    return _tableView;
}
- (MDYOrderSynquerysModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[MDYOrderSynquerysModel alloc] init];
    }
    return _infoModel;
}
@end
