//
//  MDYGoodsDetailsController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MDYGoodsDetailsController.h"
#import "MDYGoodsBannerView.h"
#import "MDYGoodsNameTableCell.h"
#import "MDYGoodsGroupManTableCell.h"
#import "MDYGroupDetailController.h"
#import "MDYBuyGoodsView.h"
#import "MDYPlaceOrderController.h"
#import "MDYShoppingCarController.h"
#import "MDYGoodsDetailRequest.h"
#import "MDYGoodsAddCarRequest.h"
#import "MDYGoodsDetailTableCell.h"
#import "MDYMyGoodsGroupRequest.h"
#import "MDYGoodsSeckillDetailRequest.h"
@interface MDYGoodsDetailsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *bottomViedw;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MDYGoodsBannerView *bannerView;
@property (nonatomic, strong) MDYGoodsDetailModel *detailModel;

@property (nonatomic, strong) NSMutableArray *groupNumData;
@property (nonatomic, strong) UIButton *shopCarButton;
@end

static NSString * const nameKey = @"nameKey";
static NSString * const groupKey = @"groupKey";
static NSString * const detailKey = @"detailKey";
@implementation MDYGoodsDetailsController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.goodsType != 2) {
        self.dataSource = @[nameKey,detailKey];
    } else {
        self.dataSource = @[nameKey,groupKey,detailKey];
    }
    [self createLeftButtonWithaboveSubview:self.tableView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getDetailData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    if (self.bottomViedw) {
        [self.bottomViedw removeFromSuperview];
        self.bottomViedw = nil;
    }
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    self.bottomViedw = bottomView;
    
    
    UIButton *shopCarButton = [UIButton k_buttonWithTarget:self action:@selector(shopCarButtonAction:)];
    [bottomView addSubview:shopCarButton];
    [shopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bottomView).insets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    [shopCarButton setImage:[UIImage imageNamed:@"shop_car_icon"] forState:UIControlStateNormal];
    if ([self.detailModel.is_seckill integerValue] != 1 && [self.detailModel.is_group integerValue] != 1) {
        shopCarButton.hidden = NO;
    } else {
        shopCarButton.hidden = YES;
    }
    self.shopCarButton = shopCarButton;
    
    MASViewAttribute *lastAttribute = shopCarButton.mas_right;
    if ([self.detailModel.is_seckill integerValue] != 1) {
        UIButton *addShopCarButton = [UIButton k_buttonWithTarget:self action:@selector(addShopCarButtonAction:)];
        [bottomView addSubview:addShopCarButton];
        [addShopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shopCarButton.mas_right);
            make.centerY.equalTo(shopCarButton.mas_centerY);
            make.width.equalTo(shopCarButton.mas_width);
        }];
        [addShopCarButton.layer setCornerRadius:4];
        [addShopCarButton.layer setBorderWidth:1];
        [addShopCarButton.layer setBorderColor:K_TextMoneyColor.CGColor];
        [addShopCarButton setBackgroundColor:K_WhiteColor];
        [addShopCarButton.titleLabel setFont:KMediumFont(16)];
        if ([self.detailModel.is_group integerValue] == 1) {
            [addShopCarButton setTitle:@"原价购买" forState:UIControlStateNormal];
        } else {
            [addShopCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        }
        [addShopCarButton setTitleColor:K_TextMoneyColor forState:UIControlStateNormal];
        lastAttribute = addShopCarButton.mas_right;
    }
    
    UIButton *buyButton = [UIButton k_buttonWithTarget:self action:@selector(buyButtonAction:)];
    [bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastAttribute).mas_offset(12);
        make.centerY.equalTo(shopCarButton.mas_centerY);
        make.width.equalTo(shopCarButton.mas_width);
        make.right.equalTo(bottomView.mas_right).mas_offset(-16);
    }];
    [buyButton.layer setCornerRadius:4];
    [buyButton setBackgroundColor:K_TextMoneyColor];
    [buyButton.titleLabel setFont:KMediumFont(16)];
    if ([self.detailModel.is_group integerValue] == 1) {
        [buyButton setTitle:@"立即拼团" forState:UIControlStateNormal];
    } else {
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    [buyButton setTitleColor:K_WhiteColor forState:UIControlStateNormal];
}
#pragma mark - Networking
/// 获取商品详情
- (void)getDetailData {
    MDYGoodsDetailRequest *request = [MDYGoodsDetailRequest new];
    request.goods_id = self.goodsId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.detailModel = response.data;
        weakSelf.bannerView.imageArray = weakSelf.detailModel.goods_imgs;
        [weakSelf createView];
        if ([weakSelf.detailModel.is_group integerValue] != 1) {
            self.dataSource = @[nameKey,detailKey];
        } else {
            self.dataSource = @[nameKey,groupKey,detailKey];
        }
        if ([weakSelf.detailModel.is_group integerValue] == 1) {
            [weakSelf getGroupData];
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)getSeckillDetailData {
    MDYGoodsSeckillDetailRequest *request = [MDYGoodsSeckillDetailRequest new];
    request.goods_id = self.goodsId;
    request.seckill_id = self.seckillId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.detailModel = response.data;
        weakSelf.bannerView.imageArray = weakSelf.detailModel.goods_imgs;
        [weakSelf createView];
        if ([weakSelf.detailModel.is_group integerValue] != 1) {
            self.dataSource = @[nameKey,detailKey];
        } else {
            self.dataSource = @[nameKey,groupKey,detailKey];
        }
        if ([weakSelf.detailModel.is_group integerValue] == 1) {
            [weakSelf getGroupData];
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
/// 获取拼团信息
- (void)getGroupData {
    MDYMyGoodsGroupRequest *request = [MDYMyGoodsGroupRequest new];
    request.page = 1;
    request.limit = 2;
    request.a_id = self.detailModel.a_id;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            weakSelf.groupNumData = [NSMutableArray arrayWithArray:response.data];
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
/// 购物车按钮
/// @param sender button
- (void)shopCarButtonAction:(UIButton *)sender {
    MDYShoppingCarController *vc = [[MDYShoppingCarController alloc] init];
    vc.noTabbar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
// 原价购买 或 加入购物车
- (void)addShopCarButtonAction:(UIButton *)sender {
    if ([self.detailModel.is_group integerValue] != 1) {
        MDYBuyGoodsView *view = [[MDYBuyGoodsView alloc] init];
        [view setGoodsModel:self.detailModel];
        CKWeakify(self);
        [view setDidClickEnter:^(NSInteger num){
            [MBProgressHUD showMessage:@"已加入购物车!"];
            MDYGoodsAddCarRequest *request = [MDYGoodsAddCarRequest new];
            request.goods_id = weakSelf.detailModel.goods_id;
            request.num = [NSString stringWithFormat:@"%ld",num];
            request.is_default = @"0";
            [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
            } failHandler:^(MDYBaseResponse * _Nonnull response) {
            }];
        }];
        [view show];
        return;
    }
    MDYPlaceOrderController *vc = [[MDYPlaceOrderController alloc] init];
    vc.goodsId = self.detailModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 立即购买按钮
/// @param sender button
- (void)buyButtonAction:(UIButton *)sender {
    MDYPlaceOrderController *vc = [[MDYPlaceOrderController alloc] init];
    if ([self.detailModel.is_group integerValue] == 1) {
        vc.addonGroupId = self.detailModel.a_id;
        vc.goodsId = @"";
    }
    vc.goodsId = self.detailModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *title = self.dataSource[section];
    if ([title isEqualToString:nameKey]) {
        return 1;
    }
    if ([title isEqualToString:groupKey]) {
        return self.groupNumData.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataSource[indexPath.section];
    if ([title isEqualToString:nameKey]) {
        MDYGoodsNameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGoodsNameTableCell.class)];
        [cell setDetailModel:self.detailModel];
        return cell;
    }
    if ([title isEqualToString:groupKey]) {
        MDYGoodsGroupManTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGoodsGroupManTableCell.class)];
        MDYMyGoodsGroupListModel *model = self.groupNumData[indexPath.row];
        [cell setModel:model];
        [cell setDidJoinGroup:^(MDYMyGoodsGroupModel * _Nonnull gourpModel) {
            MDYPlaceOrderController *vc = [[MDYPlaceOrderController alloc] init];
            vc.addonGroupId = self.detailModel.a_id;
            vc.groupId = gourpModel.group_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    if ([title isEqualToString:detailKey]) {
        MDYGoodsDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGoodsDetailTableCell.class)];
        [cell setHtmlString:self.detailModel.goods_info];
        CKWeakify(self);
        [cell setDidReloadView:^{
            [weakSelf.tableView reloadData];
        }];
        return cell;
    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:KHexColor(0xF5F5F5FF)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = self.dataSource[section];
    if ([title isEqualToString:nameKey]) {
        return 0.001f;
    }
    return 60.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = self.dataSource[section];
    if ([title isEqualToString:groupKey]) {
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:K_WhiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).mas_offset(16);
            make.centerY.equalTo(view.mas_centerY);
        }];
        [titleLabel setTextColor:K_TextGrayColor];
        [titleLabel setFont:KSystemFont(14)];
        [titleLabel setText:@"可参与拼单"];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(view.mas_right).mas_offset(-16);
        }];
        [button setTitle:@"查看更多" forState:UIControlStateNormal];
        [button.titleLabel setFont:KSystemFont(14)];
        [button setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"right_more_icon"] forState:UIControlStateNormal];
        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        return view;
    }
    if ([title isEqualToString:detailKey]) {
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:K_WhiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).mas_offset(16);
            make.centerY.equalTo(view.mas_centerY);
        }];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setFont:KMediumFont(17)];
        [titleLabel setText:@"商品详情"];
        
        UIView *lineview = [[UIView alloc] init];
        [view insertSubview:lineview atIndex:0];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(titleLabel).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(6);
        }];
        [lineview setBackgroundColor:K_MainColor];
        return view;
    }
    return nil;
}

/// 更多拼团信息
/// @param sender button
- (void)buttonAction:(UIButton *)sender {
    MDYGroupDetailController *vc = [[MDYGroupDetailController alloc] init];
    vc.goodsId = self.detailModel.goods_id;
    vc.addonGroupId = self.detailModel.a_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 50, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:self.bannerView];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGoodsNameTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGoodsNameTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGoodsGroupManTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGoodsGroupManTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGoodsDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGoodsDetailTableCell.class)];
    }
    return _tableView;
}
/// 轮播图
- (MDYGoodsBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[MDYGoodsBannerView alloc] init];
        _bannerView.frame = CGRectMake(0, 0, CK_WIDTH, 216);
        CKWeakify(self);
        [_bannerView setDidClickImage:^(SDCycleScrollView *view,NSInteger index) {
            [weakSelf showBrowerWithIndex:index data:view.imageURLStringsGroup view:view];
        }];
    }
    return _bannerView;
}
- (NSMutableArray *)groupNumData {
    if (!_groupNumData) {
        _groupNumData = [NSMutableArray array];
    }
    return _groupNumData;
}
@end
