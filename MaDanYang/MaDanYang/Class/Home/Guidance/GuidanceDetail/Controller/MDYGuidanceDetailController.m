//
//  MDYGuidanceDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYGuidanceDetailController.h"
#import "MDYGuidanceHeaderTableCell.h"
#import "MDYGuidanceDetailRequest.h"
#import "MDYGoodsDetailTableCell.h"
@interface MDYGuidanceDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MDYGuidanceDetailModel *detailModel;
@end

@implementation MDYGuidanceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"文章详情";
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadGuidanceDetail];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(likeButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 10, 40));
        make.height.width.mas_equalTo(44);
    }];
    [button setImage:[UIImage imageNamed:@"like_normal_icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"like_selected_icon"] forState:UIControlStateSelected];
    [button setTitle:@"点赞" forState:UIControlStateNormal];
    [button.titleLabel setFont:KSystemFont(12)];
    [button setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
    [button adjustButtonImageViewUPTitleDownWithSpace:8.0f];
}
#pragma mark - Networking
- (void)reloadGuidanceDetail {
    MDYGuidanceDetailRequest *request = [MDYGuidanceDetailRequest new];
    request.post_id = self.postId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == 0) {
            MDYGuidanceDetailModel *model = response.data;
            weakSelf.detailModel = model;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark _ IBAction
- (void)likeButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MDYGuidanceHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGuidanceHeaderTableCell.class)];
        cell.detailModel = self.detailModel;
        return cell;
    }
    MDYGoodsDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGoodsDetailTableCell.class)];
    [cell setHtmlString:self.detailModel.txt];
    CKWeakify(self);
    [cell setDidReloadView:^{
        [weakSelf.tableView reloadData];
    }];
    return cell;
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 64, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGuidanceHeaderTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGuidanceHeaderTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGoodsDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGoodsDetailTableCell.class)];
    }
    return _tableView;
}
@end
