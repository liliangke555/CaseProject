//
//  MDYMyAppointmentListController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/19.
//

#import "MDYMyAppointmentListController.h"
#import "MDYAppointmentListTableCell.h"
#import "MDYApplyGuidanceController.h"
#import "MDYPulicDynamicController.h"
#import "MDYMyGuidanceListRequest.h"
#import "MDYMyGuidanceDetailRequest.h"
@interface MDYMyAppointmentListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYMyAppointmentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf reloadListData];
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Netwrking
- (void)reloadListData {
    MDYMyGuidanceListRequest *request = [MDYMyGuidanceListRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.state = self.type;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        }else {
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
- (void)reloadGuidanceDetailWithId:(NSString *)guidanceId {
    MDYMyGuidanceDetailRequest *request = [MDYMyGuidanceDetailRequest new];
    request.guidance_id = guidanceId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYApplyGuidanceController *vc = [[MDYApplyGuidanceController alloc] init];
            vc.guidanceModel = response.data;
            [weakSelf.navigationController pushViewController:vc animated:YES];
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
    MDYMyGuidanceListModel *model = self.dataSource[indexPath.row];
    if (model.a_img.length > 0 || model.a_name.length > 0) {
        return 124;
    }
    return 87;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYAppointmentListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYAppointmentListTableCell.class)];
    MDYMyGuidanceListModel *model = self.dataSource[indexPath.row];
    [cell setGuidanceModel:model];
    CKWeakify(self);
    [cell setDidClickPulic:^{
        MDYPulicDynamicController *vc = [[MDYPulicDynamicController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDYMyGuidanceListModel *model = self.dataSource[indexPath.row];
    [self reloadGuidanceDetailWithId:model.guidance_id];
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"当前还没有预约数据～";
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
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 16)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYAppointmentListTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYAppointmentListTableCell.class)];
    }
    return _tableView;
}
@end
