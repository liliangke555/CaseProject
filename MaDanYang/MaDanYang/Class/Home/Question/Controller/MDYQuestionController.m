//
//  MDYQuestionController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYQuestionController.h"
#import "MDYTitleView.h"
#import "MDYHomeQuestionsCollectionCell.h"
#import "MDYHighAnswersCollectionCell.h"
#import "MDYTeacherCollectionViewCell.h"
#import "MDYToQuestionController.h"
#import "MDYAllQuestionController.h"
#import "MDYAllTeacherController.h"
#import "MDYToQuestionController.h"
#import "MDYAnswerListController.h"
#import "MDYQuestionDetailController.h"
#import "MDYTeacherListRequest.h"
#import "MDYExcellentPutQuestionsRequest.h"
#import "MDYQuestionAnswerAreaRequest.h"
@interface MDYQuestionController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *teacherData;
@property (nonatomic, strong) NSMutableArray *excellentData;
@property (nonatomic, strong) NSMutableArray *questionData;

@property (nonatomic, strong) NSArray *sectionTitles;
@end

@implementation MDYQuestionController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"问答";
    self.sectionTitles = @[@"优质问答",@"问答区",@"优质老师"];
    self.teacherData = [NSMutableArray array];
    self.excellentData = [NSMutableArray array];
    self.questionData = [NSMutableArray array];
    CKWeakify(self);
    _group = dispatch_group_create();
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getTeacherList];
        [weakSelf reloadExcellentQuestion];
        [weakSelf reloadQuestionAndAswer];
        
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
    [self createView];
}
- (void)createView {
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(10);
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, KBottomSafeHeight + 10, 16));
    }];
    [button setTitle:@"发布提问" forState:UIControlStateNormal];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
    MDYToQuestionController *vc = [[MDYToQuestionController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Networking
/// 获取优质教师列表数据
- (void)getTeacherList {
    MDYTeacherListRequest *request = [MDYTeacherListRequest new];
    request.limit = 10;
    request.page = 1;
    request.is_excellent = 1;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        weakSelf.teacherData = [NSMutableArray arrayWithArray:response.data];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)reloadExcellentQuestion {
    MDYExcellentPutQuestionsRequest *request = [MDYExcellentPutQuestionsRequest new];
    request.page = 1;
    request.limit = 10;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        if (response.code == 0) {
            weakSelf.excellentData = [NSMutableArray arrayWithArray:response.data];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)reloadQuestionAndAswer {
    MDYQuestionAnswerAreaRequest *request = [MDYQuestionAnswerAreaRequest new];
    request.page = 1;
    request.limit = 10;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        if (response.code == 0) {
            weakSelf.questionData = [NSMutableArray arrayWithArray:response.data];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CK_WIDTH - 32, 129);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(CK_WIDTH, 56);
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        [collectionView registerClass:MDYTitleView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MDYTitleView.class)];
        MDYTitleView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                 withReuseIdentifier:NSStringFromClass(MDYTitleView.class)
                                                                                        forIndexPath:indexPath];
        tempHeaderView.title = self.sectionTitles[indexPath.section];
        CKWeakify(self);
        [tempHeaderView setDidClickButton:^{
            if (indexPath.section == 0 || indexPath.section == 1) {
                MDYAllQuestionController *vc = [[MDYAllQuestionController alloc] init];
                vc.isHight = indexPath.section == 0;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                MDYAllTeacherController *vc = [[MDYAllTeacherController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        reusableView = tempHeaderView;
    }
    return reusableView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionTitles.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *string = [self.sectionTitles objectAtIndex:section];
    if ([string isEqualToString:@"优质老师"]) {
        return self.teacherData.count;
    } else if ([string isEqualToString:@"优质问答"]) {
        return self.excellentData.count;
    } else {
        return self.questionData.count;
    }
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section];
    CKWeakify(self);
    if ([string isEqualToString:@"问答区"]) {
        MDYHomeQuestionsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHomeQuestionsCollectionCell.class) forIndexPath:indexPath];
        MDYQuestionAnswerAreaModel *model = self.questionData[indexPath.row];
        [cell setAnswerModel:model];
        [cell setDidToCheckAnswer:^{
            MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    } else if ([string isEqualToString:@"优质问答"]) {
        MDYHighAnswersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHighAnswersCollectionCell.class) forIndexPath:indexPath];
        MDYExcellentPutQuestionsModel *model = self.excellentData[indexPath.row];
        [cell setExcellentModel:model];
        [cell setDidClickCheckButton:^{
            MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    } else {
        MDYTeacherListModel *model = [self.teacherData objectAtIndex:indexPath.row];
        MDYTeacherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYTeacherCollectionViewCell.class) forIndexPath:indexPath];
        [cell setTeacherModel:model];
        [cell setDidCheckBlock:^{
            MDYAnswerListController *vc = [[MDYAnswerListController alloc] init];
            vc.teacherId = model.admin_id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [cell setDidToQuestionBlock:^{
            MDYToQuestionController *vc = [[MDYToQuestionController alloc] init];
            vc.teacherModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section];
    if ([string isEqualToString:@"问答区"]) {
        MDYQuestionAnswerAreaModel *model = self.questionData[indexPath.row];
        MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
        vc.questionId = model.put_questions_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([string isEqualToString:@"优质问答"]) {
        MDYExcellentPutQuestionsModel *model = self.excellentData[indexPath.row];
        MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
        vc.questionId = model.put_questions_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 50 + 10 + 10, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHomeQuestionsCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHomeQuestionsCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHighAnswersCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHighAnswersCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYTeacherCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYTeacherCollectionViewCell.class)];
        
    }
    return _collectionView;
}

@end
