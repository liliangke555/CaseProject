//
//  MDYGroupCurrculumController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MDYGroupCurrculumController.h"
#import "MDYSearchResultTableCell.h"
#import "MDYCourseDetailController.h"
#import "MDYCurriculumGroupRequest.h"
#import "MDYGoodsGroupRequest.h"
#import "MDYGoodsDetailsController.h"
@interface MDYGroupCurrculumController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYGroupCurrculumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        if (weakSelf.index == 0) {
            [weakSelf getCurriculumListData];
        } else {
            [weakSelf getListData];
        }
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.index == 0) {
            [weakSelf getCurriculumListData];
        } else {
            [weakSelf getListData];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)getCurriculumListData {
    MDYCurriculumGroupRequest *request = [MDYCurriculumGroupRequest new];
    request.page = self.pageNum;
    request.limit = 20;
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
        if (self.dataSource.count >= response.count) {
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
- (void)getListData {
    MDYGoodsGroupRequest *request = [MDYGoodsGroupRequest new];
    request.page = self.pageNum;
    request.limit = 20;
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
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 124;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYSearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    if (self.index == 0) {
        MDYCurriculumGroupModel *model = self.dataSource[indexPath.row];
        [cell setCourseGroupModel:model];
    } else {
        MDYAllGoodsModel *model = self.dataSource[indexPath.row];
        [cell setAllGoodsModel:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.index == 0) {
        MDYCurriculumGroupModel *model = self.dataSource[indexPath.row];
        MDYCourseDetailController *vc = [[MDYCourseDetailController alloc] init];
        vc.courseId = model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MDYAllGoodsModel *model = self.dataSource[indexPath.row];
        MDYGoodsDetailsController *vc = [[MDYGoodsDetailsController alloc] init];
        vc.goodsId = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"活动未开始～";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.1)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchResultTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    }
    return _tableView;
}

@end
