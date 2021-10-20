//
//  MDYMyPointsController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYMyPointsController.h"
#import "MDYPointsMallController.h"
#import "MDYPointsDetailController.h"
#import "MDYMyIntegralAllRequest.h"
@interface MDYMyPointsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MDYMyPointsController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.dataSource = @[@"鼻科积分",@"门诊综合积分",@"其他积分"];
    self.navigationItem.title = @"我的积分";
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getAllIntegral];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(12, 0, 0, 0));
        make.height.mas_equalTo(112);
    }];
    [imageView setImage:[UIImage imageNamed:@"points_top_bg"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    UILabel *titleLable = [[UILabel alloc] init];
    [imageView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).mas_offset(24);
        make.top.equalTo(imageView.mas_top).mas_offset(28);
    }];
    [titleLable setText:@"总积分"];
    [titleLable setFont:KMediumFont(16)];
    [titleLable setTextColor:K_WhiteColor];
    
    UILabel *pointsLabel = [[UILabel alloc] init];
    [imageView addSubview:pointsLabel];
    [pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).mas_offset(24);
        make.bottom.equalTo(imageView.mas_bottom).mas_offset(-28);
    }];
    [pointsLabel setText:kUser.integral];
    [pointsLabel setFont:KMediumFont(20)];
    [pointsLabel setTextColor:K_WhiteColor];
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(49);
            make.top.equalTo(self.tableView.mas_bottom).mas_offset(10);
    }];
    [button setTitle:@"积分商城" forState:UIControlStateNormal];
    
    UIButton *detailbutton = [UIButton k_buttonWithTarget:self action:@selector(detailbuttonAction:)];
    detailbutton.frame = CGRectMake(0, 0, 60, 24);
    [detailbutton setTitle:@"积分明细" forState:UIControlStateNormal];
    [detailbutton setTitleColor:KHexColor(0xF37575FF) forState:UIControlStateNormal];
    [detailbutton.titleLabel setFont:KSystemFont(14)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailbutton];
    
}
#pragma mark - Networking
- (void)getAllIntegral {
    MDYMyIntegralAllRequest *request = [MDYMyIntegralAllRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response.code == 0) {
            weakSelf.dataSource = response.data;
            [weakSelf.tableView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
    MDYPointsMallController *vc = [[MDYPointsMallController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)detailbuttonAction:(UIButton *)sender {
    MDYPointsDetailController *vc = [[MDYPointsDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell.textLabel setFont:KSystemFont(16)];
        [cell.textLabel setTextColor:K_TextBlackColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.detailTextLabel setTextColor:K_MainColor];
        [cell.detailTextLabel setFont:KSystemFont(16)];
    }
    MDYMyIntegralAllModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@积分",model.sum_integral_num]];
    [cell.textLabel setText:model.integral_type_name];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MDYPointsMallController *vc = [[MDYPointsMallController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(122, 0, KBottomSafeHeight + 70, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 12)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_SeparatorColor];
    }
    return _tableView;
}
@end
