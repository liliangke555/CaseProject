//
//  MDYDynamicDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "MDYDynamicDetailController.h"
#import "MDYDynamicDetailTableCell.h"
#import "MDYLikeRequest.h"
@interface MDYDynamicDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *likeButton;
@end

@implementation MDYDynamicDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"晒单详情";
    [self createView];
    [self.tableView reloadData];
}
- (void)createView {
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(likeButtonAction:)];
    [self.view insertSubview:button aboveSubview:self.tableView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 10, 40));
        make.height.width.mas_equalTo(44);
    }];
    [button setImage:[UIImage imageNamed:@"like_normal_icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"like_selected_icon"] forState:UIControlStateSelected];
    [button setBackgroundColor:K_WhiteColor];
    [button setTitle:@"点赞" forState:UIControlStateNormal];
    [button.titleLabel setFont:KSystemFont(12)];
    [button setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
    [button adjustButtonImageViewUPTitleDownWithSpace:8.0f];
    [button.layer setCornerRadius:6];
    [button setClipsToBounds:YES];
    button.selected = self.homeModel.is_thumbs_up;
    self.likeButton = button;
}
#pragma mark - Networking
- (void)likeRequest {
    MDYLikeRequest *request = [MDYLikeRequest new];
    request.jl_id = self.homeModel.drying_sheet_id;
    request.type = @"2";
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            weakSelf.homeModel.is_thumbs_up = !weakSelf.homeModel.is_thumbs_up;
            weakSelf.likeButton.selected = weakSelf.homeModel.is_thumbs_up;
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
#pragma mark - IBAction
- (void)likeButtonAction:(UIButton *)sender {
    [self likeRequest];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYDynamicDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYDynamicDetailTableCell.class)];
    [cell setDynamicModel:self.homeModel];
    CKWeakify(self);
    [cell setDidReviewImage:^(NSArray *imageData, NSInteger index) {
        [weakSelf showBrowerWithIndex:index data:imageData view:nil];
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYDynamicDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYDynamicDetailTableCell.class)];
    }
    return _tableView;
}
@end
