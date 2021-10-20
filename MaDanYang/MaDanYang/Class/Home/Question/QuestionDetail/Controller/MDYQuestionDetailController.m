//
//  MDYQuestionDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYQuestionDetailController.h"
#import "MDYQuestionDetailView.h"
#import "MDYQuestionDetailAnswerTableCell.h"
#import "MDYToQuestionController.h"
#import "MDYEditQuestionController.h"
#import "MDYPutQuestionInfoRequest.h"
#import "MDYPutQuestionPayRequest.h"
#import "MDYLikeRequest.h"
@interface MDYQuestionDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) MDYQuestionDetailView *questionView;
@property (nonatomic, strong) MDYPutQuestionInfoModel *model;
@end

@implementation MDYQuestionDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提问详情";
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getINfoData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(likeButtonAction:)];
    [self.view insertSubview:button aboveSubview:self.tableView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 10, 16));
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
    self.likeButton = button;
//    if (self.isMySelf) {
//        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(editButtonAction:)];
//        [button setTitle:@"编辑" forState:UIControlStateNormal];
//        [button.titleLabel setFont:KSystemFont(16)];
//        [button setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
//        [button setFrame:CGRectMake(0, 0, 60, 34)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    }
}
#pragma mark - Networking
/// 获取问题详情
- (void)getINfoData {
    MDYPutQuestionInfoRequest *request = [MDYPutQuestionInfoRequest new];
    request.put_questions_id = self.questionId;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        MDYPutQuestionInfoModel *model = response.data;
        weakSelf.model = model;
        [weakSelf.questionView setInfoModel:model];
        weakSelf.questionView.frame = CGRectMake(0, 0, CK_WIDTH, weakSelf.model.contentHeight + 32 + 24 + 16);
        if (model.integral_num == 0) {
            weakSelf.likeButton.hidden = NO;
            weakSelf.likeButton.selected = model.is_thumbs_up;
        } else {
            weakSelf.likeButton.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
/// 支付积分查看回答
- (void)toPayRequest {
    MDYPutQuestionPayRequest *request = [MDYPutQuestionPayRequest new];
    request.put_questions_id = self.model.put_questions_id;
    request.integral_type_id = self.model.integral_type_id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)likeRequest {
    MDYLikeRequest *request = [MDYLikeRequest new];
    request.jl_id = self.questionId;
    request.type = @"1";
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [weakSelf getINfoData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
#pragma mark - IBAction
- (void)editButtonAction:(UIButton *)sender {
    MDYEditQuestionController *vc = [[MDYEditQuestionController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)likeButtonAction:(UIButton *)sender {
    [self likeRequest];
}
- (void)showPayView {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            
        } else {
            [weakSelf toPayRequest];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
        [imageView setImage:[UIImage imageNamed:@"pay_alter_icon"]];
    } detail:@"确认花费10积分来查看问题么？" items:items];
    [view show];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYQuestionDetailAnswerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYQuestionDetailAnswerTableCell.class)];
    [cell setInfoModel:self.model];
    CKWeakify(self);
    [cell setDidToQuestion:^{
        MDYToQuestionController *vc = [[MDYToQuestionController alloc] init];
        MDYTeacherListModel *tModel = [MDYTeacherListModel new];
        tModel.admin_id = weakSelf.model.admin_id;
        tModel.name = weakSelf.model.nickname;
        tModel.head_portrait = weakSelf.model.headimgurl;
//        vc.isToTeacher = YES;
        vc.teacherModel = tModel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell setDidCheckAnswer:^{
        [weakSelf showPayView];
    }];
    [cell setDidCheckAnswerImage:^(NSInteger index, NSArray * _Nonnull imageData, id view) {
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
        [_tableView setTableHeaderView:self.questionView];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYQuestionDetailAnswerTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYQuestionDetailAnswerTableCell.class)];
    }
    return _tableView;
}
- (MDYQuestionDetailView *)questionView {
    if (!_questionView) {
        _questionView = [[MDYQuestionDetailView alloc] init];
        CKWeakify(self);
        [_questionView setReviewImageView:^(NSInteger index, NSArray *imageData) {
            [weakSelf showBrowerWithIndex:index data:imageData view:nil];
        }];
    }
    return _questionView;
}
@end
