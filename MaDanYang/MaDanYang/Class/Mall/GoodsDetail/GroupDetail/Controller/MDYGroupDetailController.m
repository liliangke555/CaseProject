//
//  MDYGroupDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MDYGroupDetailController.h"
#import "MDYGoodsGroupManTableCell.h"
#import "MDYMyGoodsGroupRequest.h"
#import "MDYPlaceOrderController.h"
@interface MDYGroupDetailController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYGroupDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"更多拼团";
    self.dataSource = [NSMutableArray array];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getGroupData];
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getGroupData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)getGroupData {
    MDYMyGoodsGroupRequest *request = [MDYMyGoodsGroupRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.a_id = self.addonGroupId;
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
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                weakSelf.pageNum ++;
            }
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYGoodsGroupManTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGoodsGroupManTableCell.class)];
    MDYMyGoodsGroupListModel *model = self.dataSource[indexPath.row];
    [cell setModel:model];
    [cell setDidJoinGroup:^(MDYMyGoodsGroupModel * _Nonnull gourpModel) {
        MDYPlaceOrderController *vc = [[MDYPlaceOrderController alloc] init];
        vc.addonGroupId = gourpModel.pintuan_id;
        vc.groupId = gourpModel.group_id;
        [self.navigationController pushViewController:vc animated:YES];
    }];
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
    NSString *title = @"当前还没有更多拼团";
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(16, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.1)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGoodsGroupManTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGoodsGroupManTableCell.class)];
    }
    return _tableView;
}
@end
