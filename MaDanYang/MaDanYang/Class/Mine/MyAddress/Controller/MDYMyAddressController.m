//
//  MDYMyAddressController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MDYMyAddressController.h"
#import "MDYMyAddressTableCell.h"
#import "MDYNewAddressController.h"
#import "MDYMyAddressListRequest.h"
#import "MDYMyAddressUpDefaultRequest.h"
#import "MDYMyaddressDeleteRequest.h"
@interface MDYMyAddressController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYMyAddressController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KMediumFont(17),
        NSForegroundColorAttributeName : K_TextBlackColor,
    };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收货地址";
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getAddressList];
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getAddressList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushBUttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 10 + KBottomSafeHeight, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"新增收货地址" forState:UIControlStateNormal];
}
- (void)pushBUttonAction:(UIButton *)sender {
    MDYNewAddressController *vc = [[MDYNewAddressController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Networking
- (void)getAddressList {
    MDYMyAddressListRequest *request = [MDYMyAddressListRequest new];
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
- (void)uploadDefaultWithID:(MDYMyAddressListModel *)model {
    MDYMyAddressUpDefaultRequest *request = [MDYMyAddressUpDefaultRequest new];
    request.address_id = model.address_id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header beginRefreshing];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)deleteAddressWithID:(MDYMyAddressListModel *)model {
    MDYMyaddressDeleteRequest *request = [MDYMyaddressDeleteRequest new];
    request.address_id = model.address_id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [weakSelf.dataSource removeObject:model];
        }
        [weakSelf.tableView reloadData];
        
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYMyAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYMyAddressTableCell.class)];
    MDYMyAddressListModel *model = self.dataSource[indexPath.section];
    [cell setAddressModel:model];
    CKWeakify(self);
    [cell setDidClickEdit:^{
        MDYNewAddressController *vc = [[MDYNewAddressController alloc] init];
        vc.listModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell setDidClickSelected:^{
        [weakSelf uploadDefaultWithID:model];
    }];
    [cell setDidClickDelete:^{
        
        [weakSelf deleteAddressWithID:model];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectedAddress:)]) {
        MDYMyAddressListModel *model = self.dataSource[indexPath.section];
        [self.delegate didSelectedAddress:[model mj_keyValues]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 10)];
    [view setBackgroundColor:KHexColor(0xF8F8F8FF)];
    return view;
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"当前还没有添加地址";
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 49 + 10 + 10, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 16)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYMyAddressTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYMyAddressTableCell.class)];
    }
    return _tableView;
}
@end
