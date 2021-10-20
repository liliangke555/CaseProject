//
//  MDYMyCourseDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/26.
//

#import "MDYMyCourseDetailController.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "MDYCourseVideoView.h"
#import "MDYMyCourseInfoRequest.h"
#import "MDYMyCourseStudyRequest.h"
@interface MDYMyCourseDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *catalogueArray;

@property (nonatomic, strong) MDYCourseVideoView *videoView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation MDYMyCourseDetailController
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
    self.catalogueArray = [NSMutableArray array];
    [self.tableView reloadData];
    [self createView];
    [self createLeftButtonWithaboveSubview:self.tableView];
}
- (void)createView {
    
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
    
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        @zf_strongify(self)
        self.pageNum = 1;
        [self getMyCourseList];
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        @zf_strongify(self)
        [self getMyCourseList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)getMyCourseList {
    MDYMyCourseInfoRequest *request = [MDYMyCourseInfoRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.curriculum_my_id = self.curriculum_my_id;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.catalogueArray = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.catalogueArray addObjectsFromArray:response.data];
        }
        if (weakSelf.catalogueArray.count >= response.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)uploadStudyWithId:(NSString *)courseId {
    MDYMyCourseStudyRequest *request = [MDYMyCourseStudyRequest new];
    request.curriculum_catalog_my_id = courseId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - private
- (void)playTheIndex:(NSInteger)index {
    
    if (index >= self.catalogueArray.count) {
        [MBProgressHUD showMessage:@"还没有视频数据～"];
        return;
    }
    /// 在这里判断能否播放。。。
    MDYMyCourseInfoModel *dic = self.catalogueArray[index];
    NSString *videoUrl = dic.video_src;
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:videoUrl];
    [self.controlView showTitle:dic.curriculum_name coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
    
    if (self.tableView.contentOffset.y > self.videoView.frame.size.height) {
        [self.player addPlayerViewToSmallFloatView];
    } else {
        [self.player addPlayerViewToContainerView:self.videoView.coverImageView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.catalogueArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            [cell.textLabel setFont:KSystemFont(14)];
            [cell.textLabel setNumberOfLines:0];
            [cell.textLabel setTextColor:K_TextGrayColor];
            [cell.detailTextLabel setTextColor:K_MainColor];
            [cell.detailTextLabel setFont:KMediumFont(14)];
        }
        MDYMyCourseInfoModel *dic = self.catalogueArray[indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld、%@",indexPath.row + 1,dic.curriculum_name]];
        if ([dic.is_show integerValue] == 1) {
            [cell.detailTextLabel setText:@"已学习"];
        } else {
            [cell.detailTextLabel setText:@"未学习"];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        [cell.textLabel setFont:KMediumFont(16)];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setTextColor:K_TextBlackColor];
    }
    if (self.catalogueArray.count > self.selectedIndex) {
        MDYMyCourseInfoModel *model = self.catalogueArray[self.selectedIndex];
        [cell.textLabel setText:model.curriculum_name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        MDYMyCourseInfoModel *model = self.catalogueArray[indexPath.row];
        [self uploadStudyWithId:model.curriculum_catalog_my_id];
        self.selectedIndex = indexPath.row;
        [self playTheIndex:indexPath.row];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:KHexColor(0xFFFFFFFF)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.001f;
    }
    return 60.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
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
        [titleLabel setText:@"课程章节"];
        
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
        [_tableView setTableHeaderView:self.videoView];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
    }
    return _tableView;
}
- (MDYCourseVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[MDYCourseVideoView alloc] init];
        _videoView.frame = CGRectMake(0, 0, CK_WIDTH, 9/16.0 * CK_WIDTH);
        CKWeakify(self);
        [_videoView setPlayCallback:^{
            [weakSelf playTheIndex:0];
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
