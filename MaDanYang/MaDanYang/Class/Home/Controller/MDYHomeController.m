//
//  MDYHomeController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/3.
//

#import "MDYHomeController.h"
#import "MDYHeaderBannerView.h"
#import "MDYTitleView.h"
#import "MDYItmeCollectionCell.h"
#import "MDYCurriculumCollectionCell.h"
#import "MDYHomeQuestionsCollectionCell.h"
#import "MDYHomeDynamicCollectionCell.h"
#import "MDYSearchController.h"
#import "MDYCurriculumController.h"
#import "MDYAllCurriculumController.h"
#import "MDYLiveRoomMianController.h"
#import "MDYQuestionController.h"
#import "MDYDynamicAreaController.h"
#import "MDYDynamicDetailController.h"
#import "MDYGuidanceController.h"
#import "MDYSigninController.h"
#import "MDYSharController.h"
#import "MDYTimeLImitedController.h"
#import "MDYGroupBuyController.h"
#import "MDYMyServiceController.h"
#import "MDYCourseDetailController.h"
#import "MDYQuestionDetailController.h"
#import "MDYHomeBannerRequest.h"
#import "MDYHomeFreeCourseRequest.h"
#import "MDYHomeExclusiveCourseRequest.h"
#import "MDYHomeQuestionRequest.h"
#import "MDYHomeDynamicRequest.h"
#import "MDYAllQuestionController.h"
#import "MDYSigninAlterView.h"
#import "MDYSigninRequest.h"
#import "MDYWechatOfficialAccountRequest.h"
#import "MDYPayDryingSheetRequest.h"
@interface MDYHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,MDYItemCollectionCellDelegate> {
    dispatch_group_t _group;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *freeCourseData;
@property (nonatomic, strong) NSArray *exclusiveCourseData;
@property (nonatomic, strong) NSArray *questionData;
@property (nonatomic, strong) NSArray *dynamicData;

@property (nonatomic, strong) NSMutableArray *homeImageModels;

@end

@implementation MDYHomeController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sectionTitles = @[@"免费课程",@"专属课程",@"提问",@"晒单区"];
    self.homeImageModels = [NSMutableArray array];
    [self createView];
    [self.collectionView reloadData];
    CKWeakify(self);
    _group = dispatch_group_create();
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getBannerData];
        [weakSelf getFreeCourse];
        [weakSelf getExclusiveCourseData];
        [weakSelf getHomeQuestionData];
        [weakSelf getDynamicData];
        
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)createView {
    UIImageView *backImageView = [[UIImageView alloc] init];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [backImageView setImage:[UIImage imageNamed:@"home_top_back"]];
    
    UIView *searchView = [[UIView alloc] init];
//    searchView.frame = CGRectMake(0, 0, CK_WIDTH - 32, 34);
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(KStatusBarHeight + 8, 16, 0, 16));
        make.height.mas_equalTo(34);
    }];
    [searchView setBackgroundColor:KHexColor(0xFFFFFF66)];
    [searchView.layer setCornerRadius:6];
    [searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSearch)]];
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).mas_offset(8);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    [searchIcon setImage:[UIImage imageNamed:@"home_search_icon"]];
    
    UILabel *searchLabel = [[UILabel alloc] init];
    [searchView addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).mas_offset(8);
        make.centerY.equalTo(searchIcon.mas_centerY);
    }];
    [searchLabel setFont:KSystemFont(14)];
    [searchLabel setText:@"搜索"];
    [searchLabel setTextColor:K_WhiteColor];
}
#pragma mark - Networking
/// 获取轮播图
- (void)getBannerData {
    MDYHomeBannerRequest *request = [MDYHomeBannerRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.homeImageModels = response.data;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 获取免费课程数据
- (void)getFreeCourse {
    MDYHomeFreeCourseRequest *request = [MDYHomeFreeCourseRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.freeCourseData = response.data;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 获取专属课程数据
- (void)getExclusiveCourseData {
    MDYHomeExclusiveCourseRequest *request = [MDYHomeExclusiveCourseRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.exclusiveCourseData = response.data;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 获取提问数据
- (void)getHomeQuestionData {
    MDYHomeQuestionRequest *request = [MDYHomeQuestionRequest new];
    request.hideLoadingView = YES;
    request.page = 1;
    request.limit = 6;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.questionData = response.data;
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 获取晒单数据
- (void)getDynamicData {
    MDYHomeDynamicRequest *request = [MDYHomeDynamicRequest new];
    request.hideLoadingView = YES;
    request.page = 1;
    request.limit = 6;
    request.is_index = 1;
    request.is_excellent = 0;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
/// 签到接口
- (void)postSignin {
    MDYSigninRequest *request = [MDYSigninRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYSigninModel *model = response.data;
            if ([model.msg integerValue] == 0 && model) {
                MDYSigninController *vc = [[MDYSigninController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                [weakSelf showSigninAlter];
            }
        } else {
            
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)followWeChatOfficialAccountRequest {
    MDYWechatOfficialAccountRequest *request = [MDYWechatOfficialAccountRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYWechatOfficialAccountModel *model = response.data;
            CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] init];
            vc.htmlString = model.txt;
            vc.title = @"关注公众号";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 签到成功弹窗
- (void)showSigninAlter {
    CKWeakify(self);
    MDYSigninAlterView *view = [[MDYSigninAlterView alloc] initWithImage:^(UIImageView *imageView) {
        [imageView setImage:[[UIImage imageNamed:@"signin_alter_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(120, 150, 180, 150) resizingMode:UIImageResizingModeStretch]];
    } title:@"签到成功" detail:@"您已成功签到\n获得一次抽奖机会~" button:@"点击进入抽奖" didSelected:^{
        MDYSigninController *vc = [[MDYSigninController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [view show];
}
- (void)showPayViewWithModel:(MDYHomeDynamicModel *)model {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
//            [weakSelf pushTZImagePickerController];
        } else {
            [weakSelf payDryingWithId:model];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
        [imageView setImage:[UIImage imageNamed:@"pay_alter_icon"]];
    } detail:@"确认花费10积分来查看晒单么？" items:items];
    [view show];
}
- (void)payDryingWithId:(MDYHomeDynamicModel *)model {
    MDYPayDryingSheetRequest *request = [MDYPayDryingSheetRequest new];
    request.drying_sheet_id = model.drying_sheet_id;
    request.integral_type_id = @"";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            model.integral_num = 0;
            [weakSelf.collectionView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
/// 点击搜索事件
- (void)didClickSearch {
    MDYSearchController *vc = [[MDYSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MDYItemCollectionCellDelegate
- (void)didSelectedIndex:(NSString *)title {
    if ([title isEqualToString:@"免费课程"]) {
        MDYCurriculumController *vc = [[MDYCurriculumController alloc] init];
        vc.navigationItem.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"全部课程"]) {
        MDYAllCurriculumController *vc = [[MDYAllCurriculumController alloc] init];
        vc.navigationItem.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"直播间"]) {
        MDYLiveRoomMianController *vc = [[MDYLiveRoomMianController alloc] init];
        vc.navigationItem.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"提问"]) {
        MDYQuestionController *vc = [[MDYQuestionController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"晒单区"]) {
        MDYDynamicAreaController *vc = [[MDYDynamicAreaController alloc] init];
        vc.navigationItem.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"上门指导"]) {
        MDYGuidanceController *vc = [[MDYGuidanceController alloc] init];
        vc.navigationItem.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"签到抽奖"]) {
        [self postSignin];
    } else if ([title isEqualToString:@"分享有礼"]) {
        MDYSharController *vc = [[MDYSharController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"限时秒杀"]) {
        MDYTimeLImitedController *vc = [[MDYTimeLImitedController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"拼团抢购"]) {
        MDYGroupBuyController *vc = [[MDYGroupBuyController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"联系客服"]) {
        MDYMyServiceController *vc = [[MDYMyServiceController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"关注公众号"]) {
        [self followWeChatOfficialAccountRequest];
    }
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0 && indexPath.section == 0) {
        return CGSizeMake(CK_WIDTH - 32, 60*3 + 32 + 32);
    }
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section - 1];
    if ([string isEqualToString:@"免费课程"] || [string isEqualToString:@"专属课程"]) {
        return CGSizeMake((CK_WIDTH - 32 - 16) / 2.0f, 183);
    }
    if ([string isEqualToString:@"提问"]) {
        return CGSizeMake(CK_WIDTH - 32, 129);
    }
    if ([string isEqualToString:@"晒单区"]) {
        MDYHomeDynamicModel *model = self.dataSource[indexPath.item];
        return CGSizeMake(CK_WIDTH - 32, 96 + model.cellHeight);
    }
    return CGSizeMake(CK_WIDTH - 32, 52);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(CK_WIDTH, 154);
    }
    CGSize size = CGSizeMake(CK_WIDTH, 56);
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            [collectionView registerClass:MDYHeaderBannerView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MDYHeaderBannerView.class)];
            MDYHeaderBannerView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(MDYHeaderBannerView.class)
                                                                                            forIndexPath:indexPath];
            [tempHeaderView setHomeImageModels:self.homeImageModels];
            CKWeakify(self);
            [tempHeaderView setDidSelectedIndex:^(NSInteger index) {
                MDYHomeBannerModel *model = weakSelf.homeImageModels[index];
                if (model.url.length > 0) {
                    CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] init];
                    vc.stringUrl = model.url;
                    vc.title = model.miaoshu;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
            reusableView = tempHeaderView;
        } else {
            [collectionView registerClass:MDYTitleView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MDYTitleView.class)];
            MDYTitleView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(MDYTitleView.class)
                                                                                            forIndexPath:indexPath];
            tempHeaderView.title = self.sectionTitles[indexPath.section - 1];
            CKWeakify(self);
            __weak typeof(tempHeaderView)weakView = tempHeaderView;
            [tempHeaderView setDidClickButton:^{
                if ([weakView.title isEqualToString:@"晒单区"]) {
                    MDYDynamicAreaController *vc = [[MDYDynamicAreaController alloc] init];
                    vc.navigationItem.title = weakView.title;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                if ([weakView.title isEqualToString:@"免费课程"]) {
                    MDYCurriculumController *vc = [[MDYCurriculumController alloc] init];
                    vc.navigationItem.title = weakView.title;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([weakView.title isEqualToString:@"专属课程"]) {
                    MDYAllCurriculumController *vc = [[MDYAllCurriculumController alloc] init];
                    vc.exclusive = YES;
                    vc.navigationItem.title = weakView.title;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([weakView.title isEqualToString:@"提问"]) {
                    MDYAllQuestionController *vc = [[MDYAllQuestionController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            reusableView = tempHeaderView;
        }
    }
    return reusableView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionTitles.count + 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSString *string = [self.sectionTitles objectAtIndex:section - 1];
    if ([string isEqualToString:@"晒单区"]) {
        return self.dataSource.count;
    }
    if ([string isEqualToString:@"免费课程"]) {
        return self.freeCourseData.count;
    }
    if ([string isEqualToString:@"专属课程"]) {
        return self.exclusiveCourseData.count;
    }
    if ([string isEqualToString:@"提问"]) {
        return self.questionData.count;
    }
    return 6;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MDYItmeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYItmeCollectionCell.class) forIndexPath:indexPath];
        cell.dataSource = @[@{titleKey:@"免费课程",imageKey:@"home_free_icon"},
                            @{titleKey:@"全部课程",imageKey:@"home_exclusive_icon"},
                            @{titleKey:@"直播间",imageKey:@"home_live_icon"},
                            @{titleKey:@"提问",imageKey:@"home_questions_icon"},
                            @{titleKey:@"晒单区",imageKey:@"home_exhibition_icon"},
                            @{titleKey:@"上门指导",imageKey:@"home_guidance_icon"},
                            @{titleKey:@"分享有礼",imageKey:@"home_share_icon"},
                            @{titleKey:@"签到抽奖",imageKey:@"home_signin_icon"},
                            @{titleKey:@"关注公众号",imageKey:@"home_official_icon"},
                            @{titleKey:@"限时秒杀",imageKey:@"home_time_icon"},
                            @{titleKey:@"拼团抢购",imageKey:@"home_group_icon"},
                            @{titleKey:@"联系客服",imageKey:@"home_free_icon"},];
        cell.delegate = self;
        return cell;
    }
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section - 1];
    if ([string isEqualToString:@"免费课程"]) {
        MDYCurriculumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYCurriculumCollectionCell.class) forIndexPath:indexPath];
        cell.freeModel = self.freeCourseData[indexPath.row];
        return cell;
    }
    if ([string isEqualToString:@"专属课程"]) {
        MDYCurriculumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYCurriculumCollectionCell.class) forIndexPath:indexPath];
        cell.exclusiveModel = self.exclusiveCourseData[indexPath.row];
        return cell;
    }
    if ([string isEqualToString:@"提问"]) {
        MDYHomeQuestionsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHomeQuestionsCollectionCell.class) forIndexPath:indexPath];
        MDYHomeQuestionModel *model = self.questionData[indexPath.row];
        [cell setHomeQuestionModel:model];
        CKWeakify(self);
        [cell setDidToCheckAnswer:^{
            MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    if ([string isEqualToString:@"晒单区"]) {
        MDYHomeDynamicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHomeDynamicCollectionCell.class) forIndexPath:indexPath];
        MDYHomeDynamicModel *model = self.dataSource[indexPath.item];
        cell.name = model.nickname;
        cell.time = model.car_time;
        cell.headerImage = model.headimgurl;
        cell.detail = model.txt;
        cell.images = model.imgs;
        cell.integralNum = labs(model.integral_num);
        __weak typeof(model)weakModel = model;
        CKWeakify(self);
        [cell setDidCheckImage:^(NSInteger index) {
            [weakSelf showBrowerWithIndex:index data:weakModel.imgs view:nil];
        }];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = K_WhiteColor;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 0) {
        return;
    }
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section - 1];
    if ([string isEqualToString:@"晒单区"]) {
        MDYHomeDynamicModel *model = self.dataSource[indexPath.item];
        if (labs(model.integral_num) > 0) {
            [self showPayViewWithModel:model];
            return;
        }
        MDYDynamicDetailController *vc = [[MDYDynamicDetailController alloc] init];
        vc.homeModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([string isEqualToString:@"免费课程"]) {
        MDYFreeCourseModel *model = self.freeCourseData[indexPath.row];
        MDYCourseDetailController *vc = [[MDYCourseDetailController alloc] init];
        vc.courseType = 3;
        vc.courseId = model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([string isEqualToString:@"专属课程"]) {
        MDYFreeCourseModel *model = self.exclusiveCourseData[indexPath.row];
        MDYCourseDetailController *vc = [[MDYCourseDetailController alloc] init];
        vc.courseId = model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([string isEqualToString:@"提问"]) {
        MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
        MDYHomeQuestionModel *model = self.questionData[indexPath.row];
        vc.questionId = model.put_questions_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        [flowLayout setMinimumInteritemSpacing:16];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight + 10, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYItmeCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYItmeCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYCurriculumCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYCurriculumCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHomeQuestionsCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHomeQuestionsCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHomeDynamicCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHomeDynamicCollectionCell.class)];
        
    }
    return _collectionView;
}
- (NSArray *)dataSource  {
    if (!_dataSource) {
        NSMutableArray *array = [NSMutableArray array];
        _dataSource = array;
    }
    return _dataSource;
}
@end
