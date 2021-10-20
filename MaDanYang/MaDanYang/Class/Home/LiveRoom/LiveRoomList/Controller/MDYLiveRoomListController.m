//
//  MDYLiveRoomListController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYLiveRoomListController.h"
#import "MDYLiveRoomTableCell.h"
#import "MDYLiveRoomLockView.h"
#import "MDYLiveDetailController.h"
#import "MDYObsLiveListRequest.h"
#import "MDYObsLiveIsShowRequest.h"
#import "MDYObsLiveinfoRequest.h"
#import "MDYLivePlayBackController.h"
@interface MDYLiveRoomListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYLiveRoomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [ NSMutableArray array];
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
#pragma mark - Networking
- (void)reloadListData {
    MDYObsLiveListRequest *request = [MDYObsLiveListRequest new];
    request.limit = 20;
    request.page = self.pageNum;
    request.live_state = self.liveState;
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
- (void)cancelOrEnterSHowWithId:(NSString *)liveId {
    MDYObsLiveIsShowRequest *request = [MDYObsLiveIsShowRequest new];
    request.obs_live_id = liveId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
- (void)getLiveInfoWithId:(NSString *)liveId code:(NSString *)code {
    MDYObsLiveinfoRequest *request = [MDYObsLiveinfoRequest new];
    request.obs_live_id = liveId;
    request.invitation_code = code;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYLiveDetailController *vc = [[MDYLiveDetailController alloc] init];
            vc.model = response.data;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYLiveRoomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYLiveRoomTableCell.class)];
    MDYObsLiveListModel *model = self.dataSource[indexPath.row];
    [cell setListModel:model];
    CKWeakify(self);
    [cell setDidShowAction:^{
        [weakSelf cancelOrEnterSHowWithId:model.obs_live_id];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDYObsLiveListModel *model = self.dataSource[indexPath.row];
    if ([model.live_state integerValue] == 1) {
        if ([model.is_pay integerValue] == 1) {
            MDYLiveRoomLockView *view = [[MDYLiveRoomLockView alloc] init];
            view.model = model;
            CKWeakify(self);
            [view setDidClickEnter:^(NSString * _Nonnull string) {
                [weakSelf getLiveInfoWithId:model.obs_live_id code:string];
            }];
            [view show];
        } else {
            [self getLiveInfoWithId:model.obs_live_id code:@""];
        }
    }
    if ([model.live_state integerValue] == 2 || [model.live_state integerValue] == 0) {
        MDYLivePlayBackController *vc = [MDYLivePlayBackController new];
        if ([model.live_state integerValue] == 0) {
            vc.luboString = model.live_notice;
        } else {
            vc.luboString = model.lubo;
        }
        vc.notice = [model.live_state integerValue] == 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 12)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYLiveRoomTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYLiveRoomTableCell.class)];
    }
    return _tableView;
}
@end
