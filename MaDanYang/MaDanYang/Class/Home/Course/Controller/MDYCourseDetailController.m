//
//  MDYCourseDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import "MDYCourseDetailController.h"
#import "MDYCoursePlaceOrderController.h"
#import "MDYGroupDetailController.h"
#import "MDYCourseVideoView.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "MDYCourseTitleTableCell.h"
#import "MDYCourseSelectView.h"
#import "MDYCourseDetailTableCell.h"
#import "MDYSearchResultTableCell.h"
#import "MDYGoodsGroupManTableCell.h"
#import "MDYCourseTImeKillTableCell.h"
#import "MDYGoodsDetailsController.h"
#import "MDYCourseDetailRequest.h"
#import "MDYCourseCatalogueRequest.h"
#import "MDYCourseGoodsReqeust.h"
#import "MDYAddMyCourseInfoRequest.h"
#import "MDYBuyGoodsView.h"
#import "MDYPlatformCerController.h"
#import "MDYCourseSeckillDetailRequest.h"
#import "MDYEmptyDataTableCell.h"
@interface MDYCourseDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *catalogueArray;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSMutableArray *groupNumData;

@property (nonatomic, strong) MDYCourseVideoView *videoView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) MDYCourseDetailModel *detailModel;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *originBuyButton;
@property (nonatomic, assign, getter=isOriginBuy) BOOL originBuy;
@end
static NSString * const nameKey = @"nameKey";
static NSString * const groupKey = @"groupKey";
static NSString * const timeKillKey = @"timeKillKey";
static NSString * const detailKey = @"detailKey";
@implementation MDYCourseDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.player.viewControllerDisappear = NO;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    self.player.viewControllerDisappear = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.goodsArray = [NSMutableArray array];
    self.groupNumData = [NSMutableArray array];
    [self createView];
    [self createLeftButtonWithaboveSubview:self.tableView];
    CKWeakify(self);
    _group = dispatch_group_create();
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        if (self.courseType == 1) {
            [weakSelf getCourseSeckillDetail];
        } else {
            [weakSelf getCourseDetailData];
        }
        [weakSelf getCourseCatalogue];
        [weakSelf getCourseGoods];
        
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    MASViewAttribute *lastAttribute = bottomView.mas_right;
    
    UIButton *buyButton = [UIButton k_redButtonWithTarget:self action:@selector(buyButtonAction:)];
    [bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastAttribute).mas_offset(-12);
        make.top.equalTo(bottomView.mas_top).mas_offset(5);
        make.width.mas_equalTo(147);
        make.height.mas_equalTo(41);
    }];
    self.buyButton = buyButton;
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    
    UIButton *addShopCarButton = [UIButton k_buttonWithTarget:self action:@selector(addShopCarButtonAction:)];
    [bottomView addSubview:addShopCarButton];
    [addShopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).mas_offset(-8);
        make.centerY.equalTo(buyButton.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.equalTo(buyButton.mas_height);
    }];
    [addShopCarButton.layer setCornerRadius:4];
    [addShopCarButton.layer setBorderWidth:1];
    [addShopCarButton.layer setBorderColor:K_TextMoneyColor.CGColor];
    [addShopCarButton setBackgroundColor:K_WhiteColor];
    [addShopCarButton.titleLabel setFont:KMediumFont(16)];
    [addShopCarButton setTitle:@"原价购买" forState:UIControlStateNormal];
    [addShopCarButton setTitleColor:K_TextMoneyColor forState:UIControlStateNormal];
    addShopCarButton.hidden = YES;
    self.originBuyButton = addShopCarButton;
    lastAttribute = addShopCarButton.mas_right;
    
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerView:self.videoView.coverImageView];
    self.player.playerDisapperaPercent = 1.0;
    self.player.playerApperaPercent = 0.0;
    self.player.stopWhileNotVisible = NO;
    CGFloat margin = 20;
    CGFloat w = CK_WIDTH/2;
    CGFloat h = w * 9/16;
    CGFloat x = CK_WIDTH - w - margin;
    CGFloat y = CK_HEIGHT - h - margin;
    self.player.smallFloatView.frame = CGRectMake(x, y, w, h);
    self.player.controlView = self.controlView;
    
    @zf_weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        kAPPDelegate.allowOrentitaionRotation = isFullScreen;
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @zf_strongify(self)
        [self.player stopCurrentPlayingCell];
    };
}
#pragma mark - Private
- (void)showEnterView {
    MDYBuyGoodsView *view = [[MDYBuyGoodsView alloc] init];
    [view setCourseModel:self.detailModel];
    CKWeakify(self);
    [view setDidClickEnter:^(NSInteger num){
        [weakSelf toPlaceOrderView];
    }];
    [view show];
}
- (void)toPlaceOrderView {
    MDYCoursePlaceOrderController *vc = [[MDYCoursePlaceOrderController alloc] init];
    if ([self.detailModel.is_group integerValue] == 1) {
        if (self.isOriginBuy) {
            
        } else {
            vc.a_id = self.detailModel.a_id;
            vc.groupId = @"";
        }
    }
    vc.courseId = self.detailModel.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - IBAction
/// 原价购买按钮
/// @param sender button
- (void)addShopCarButtonAction:(UIButton *)sender {
    self.originBuy = YES;
    [self showEnterView];
}
/// 立即购买按钮
/// @param sender button
- (void)buyButtonAction:(UIButton *)sender {
    if ([self.detailModel.is_pay integerValue] == 0) {
        [self addMyCourse];
        return;
    }
    self.originBuy = NO;
    [self showEnterView];
}
#pragma mark - private
/// 播放下一个视频
/// @param index 播放的index
- (void)playTheIndex:(NSInteger)index {
    /// 在这里判断能否播放。。。
    MDYCourseCatalogueModel *model = self.catalogueArray[index];
    if (model.video_src.length <= 0) {
        [MBProgressHUD showMessage:@"当前视频不可播放"];
        return;
    }
    NSString *videoUrl = model.video_src;
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:videoUrl];
    [self.controlView showTitle:model.name coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
    
    if (self.tableView.contentOffset.y > self.videoView.frame.size.height) {
        [self.player addPlayerViewToSmallFloatView];
    } else {
        [self.player addPlayerViewToContainerView:self.videoView.coverImageView];
    }
}
/// 播放试看视频
- (void)playVideo {
    if (self.detailModel.src_trial.length <=0) {
        [MBProgressHUD showMessage:@"暂无可播放视频"];
        return;
    }
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:self.detailModel.src_trial];
    [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
    
    if (self.tableView.contentOffset.y > self.videoView.frame.size.height) {
        [self.player addPlayerViewToSmallFloatView];
    } else {
        [self.player addPlayerViewToContainerView:self.videoView.coverImageView];
    }
}
#pragma mark - NEtworking
/// 获取课程详情
- (void)getCourseDetailData {
    MDYCourseDetailRequest *request = [MDYCourseDetailRequest new];
    request.c_id = self.courseId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        MDYCourseDetailModel *model = response.data;
        weakSelf.detailModel = model;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)getCourseSeckillDetail {
    MDYCourseSeckillDetailRequest *request = [MDYCourseSeckillDetailRequest new];
    request.curriculum_id = self.courseId;
    request.seckill_id = self.seckillId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        MDYCourseDetailModel *model = response.data;
        weakSelf.detailModel = model;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 获取课程目录
- (void)getCourseCatalogue {
    MDYCourseCatalogueRequest *request = [MDYCourseCatalogueRequest new];
    request.c_id = [self.courseId integerValue];
    request.page = 1;
    request.limit = 100;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.catalogueArray = response.data;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 获取课程关联的商品
- (void)getCourseGoods {
    MDYCourseGoodsReqeust *request = [MDYCourseGoodsReqeust new];
    request.c_id = [self.courseId integerValue];
    request.page = 1;
    request.limit = 100;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.goodsArray = response.data;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 免费课程加入我的课程
- (void)addMyCourse {
    MDYAddMyCourseInfoRequest *request = [MDYAddMyCourseInfoRequest new];
    request.c_id = self.detailModel.uid;
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showMessage:@"已加入我的课程"];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
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
            NSArray *array = response.data;
            if (array.count > 2) {
                weakSelf.groupNumData = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 2)]];
            } else {
                weakSelf.groupNumData = [NSMutableArray arrayWithArray:array];
            }
            
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *title = self.dataSource[section];
    if ([title isEqualToString:groupKey]) {
        return self.groupNumData.count;
    }
    if ([title isEqualToString:detailKey]) {
        if (self.selectedIndex == 0) {
            return 1;
        } else if (self.selectedIndex == 1) {
            return self.catalogueArray.count <= 0 ? 1 : self.catalogueArray.count;
        } else {
            return self.goodsArray.count <= 0 ? 1 : self.goodsArray.count;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataSource[indexPath.section];
    if ([title isEqualToString:nameKey]) {
        MDYCourseTitleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYCourseTitleTableCell.class)];
        cell.detailModel = self.detailModel;
        return cell;
    }
    if ([title isEqualToString:groupKey]) {
        MDYGoodsGroupManTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYGoodsGroupManTableCell.class)];
        MDYMyGoodsGroupListModel *model = self.groupNumData[indexPath.row];
        [cell setModel:model];
        CKWeakify(self);
        [cell setDidJoinGroup:^(MDYMyGoodsGroupModel * _Nonnull model) {
            MDYCoursePlaceOrderController *vc = [[MDYCoursePlaceOrderController alloc] init];
            vc.a_id = self.detailModel.a_id;
            vc.groupId = model.group_id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    if ([title isEqualToString:timeKillKey]) {
        MDYCourseTImeKillTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYCourseTImeKillTableCell.class)];
        cell.countDownTime = [self.detailModel.end_time integerValue];
        return cell;
    }
    if ([title isEqualToString:detailKey]) {
        if (self.selectedIndex == 0) {
            MDYCourseDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYCourseDetailTableCell.class)];
            cell.detailModel = self.detailModel;
            CKWeakify(self);
            [cell setDidReloadView:^{
                [weakSelf.tableView reloadData];
            }];
            return cell;
        } else if (self.selectedIndex == 1) {
            if (self.catalogueArray.count <= 0) {
                MDYEmptyDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYEmptyDataTableCell.class)];
                cell.titleString = @"还没有目录～";
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                [cell.textLabel setFont:KSystemFont(14)];
                [cell.textLabel setNumberOfLines:0];
                [cell.textLabel setTextColor:K_TextGrayColor];
            }
            MDYCourseCatalogueModel *model = self.catalogueArray[indexPath.row];
            [cell.textLabel setText:[NSString stringWithFormat:@"%ld、%@",indexPath.row + 1,model.name]];
            return cell;
        } else {
            if (self.goodsArray.count <= 0) {
                MDYEmptyDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYEmptyDataTableCell.class)];
                cell.titleString = @"还没有关联商品～";
                return cell;
            }
            MDYSearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
            MDYCourseGoodsModel *model = self.goodsArray[indexPath.row];
            cell.courseGoodsModel = model;
            return cell;
        }
    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.dataSource[indexPath.section];
    if ([title isEqualToString:detailKey]) {
        if (self.selectedIndex == 1) {
//            [self playTheIndex:indexPath.row];
        } else if (self.selectedIndex == 2) {
            MDYCourseGoodsModel *model = self.goodsArray[indexPath.row];
            MDYGoodsDetailsController *vc = [[MDYGoodsDetailsController alloc] init];
            vc.goodsId = model.goods_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
    if ([title isEqualToString:nameKey] || [title isEqualToString:timeKillKey]) {
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
        MDYCourseSelectView *view = [[MDYCourseSelectView alloc] init];
        [view setBackgroundColor:K_WhiteColor];
        view.selectedIndex = self.selectedIndex;
        CKWeakify(self);
        [view setDidSelected:^(NSInteger index) {
            weakSelf.selectedIndex = index;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [view setDidPushCertification:^{
            MDYPlatformCerController *vc = [[MDYPlatformCerController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return view;
    }
    return nil;
}
/// 更多拼团按钮
/// @param sender button
- (void)buttonAction:(UIButton *)sender {
    MDYGroupDetailController *vc = [[MDYGroupDetailController alloc] init];
    vc.addonGroupId = self.detailModel.a_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Setter
- (void)setDetailModel:(MDYCourseDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel) {
        if ([detailModel.is_pay integerValue] == 0) {
            [self.buyButton setTitle:@"加入我的课程" forState:UIControlStateNormal];
        } else {
            [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        }
        self.dataSource = @[nameKey,detailKey];
        if ([detailModel.is_group integerValue] == 1) {
            [self.buyButton setTitle:@"立即拼团" forState:UIControlStateNormal];
            self.originBuyButton.hidden = NO;
            self.dataSource = @[nameKey,groupKey,detailKey];
            [self getGroupData];
        }
        if ([detailModel.is_seckill integerValue] == 1) {
            [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
            self.originBuyButton.hidden = YES;
            self.dataSource = @[nameKey,timeKillKey,detailKey];
        }
    }
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
        [_tableView setTableHeaderView:self.videoView];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYCourseTitleTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYCourseTitleTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYCourseDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYCourseDetailTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchResultTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYGoodsGroupManTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYGoodsGroupManTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYCourseTImeKillTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYCourseTImeKillTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYEmptyDataTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYEmptyDataTableCell.class)];
    }
    return _tableView;
}
- (MDYCourseVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[MDYCourseVideoView alloc] init];
        _videoView.frame = CGRectMake(0, 0, CK_WIDTH, 9/16.0 * CK_WIDTH);
        CKWeakify(self);
        [_videoView setPlayCallback:^{
            [weakSelf playVideo];
        }];
    }
    return _videoView;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}
@end
