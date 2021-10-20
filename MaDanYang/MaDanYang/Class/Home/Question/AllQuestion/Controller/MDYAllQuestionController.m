//
//  MDYAllQuestionController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYAllQuestionController.h"
#import "MDYCurriculumListTableCell.h"
#import "MDYSearchResultTableCell.h"
#import "MDYAllQuestionTableCell.h"
#import "MDYAllQuestionHightView.h"
#import "MDYQuestionDetailController.h"
#import "MDYQuestionTypeRequest.h"
#import "MDYTypeInquestionRequest.h"
@interface MDYAllQuestionController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation MDYAllQuestionController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"全部问答";
    self.listData = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    
    [self getTypeData];
    CKWeakify(self);
    self.contentTableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        MDYQuestionTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
        [weakSelf getQuestionWithType:model];
    }];
    self.contentTableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        MDYQuestionTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
        [weakSelf getQuestionWithType:model];
    }];
}
/// 优质选择器
/// @param sender switch
- (void)switchChangeValue:(UISwitch *)sender {
    self.isHight = sender.isOn;
    [self.contentTableView.mj_header beginRefreshing];
}
#pragma mark - Networking
/// 获取问题类型
- (void)getTypeData {
    MDYQuestionTypeRequest *request = [MDYQuestionTypeRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        weakSelf.listData = [NSMutableArray arrayWithArray:response.data];
        [weakSelf.listTableView reloadData];
        NSInteger selectedIndex = 0;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [weakSelf.listTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [weakSelf.contentTableView.mj_header beginRefreshing];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
    }];
}
/// 获取该类型下的问题列表
/// @param typeModel 问题类型
- (void)getQuestionWithType:(MDYQuestionTypeModel *)typeModel {
    MDYTypeInquestionRequest *request = [MDYTypeInquestionRequest new];
    request.hideLoadingView = YES;
    request.page = self.pageNum;
    request.limit = 20;
    request.integral_type_id = typeModel.integral_type_id;
    request.is_excellent = self.isHight ? @"1" : @"0";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.contentTableView.mj_header endRefreshing];
        [weakSelf.contentTableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        weakSelf.pageNum ++;
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.contentTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.contentTableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.contentTableView.mj_header endRefreshing];
        [weakSelf.contentTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        MDYAllQuestionHightView *view = [[MDYAllQuestionHightView alloc] init];
        view.isHight = self.isHight;
//        [view.selectedSwitch addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
        CKWeakify(self);
        [view setDidSelectedSwitch:^(UIButton * _Nonnull sender) {
            weakSelf.isHight = sender.isSelected;
            [weakSelf.contentTableView.mj_header beginRefreshing];
        }];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return 50.0f;
    }
    return 0.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.listData.count;
    } else {
        return self.dataSource.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        MDYCurriculumListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MDYCurriculumListTableCell class])];
        if (!cell) {
            cell = [[MDYCurriculumListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MDYCurriculumListTableCell class])];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.minimumScaleFactor = 0.5;
        }
        MDYQuestionTypeModel *model = self.listData[indexPath.row];
        [cell.textLabel setText:model.type_name];
        return cell;
    } else {
        MDYAllQuestionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYAllQuestionTableCell.class)];
        MDYTypeInquestionModel *model = self.dataSource[indexPath.row];
        [cell setQuestionModel:model];
        CKWeakify(self);
        [cell setDidToCheckAnswer:^{
            MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
            vc.questionId = model.put_questions_id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        self.selectedIndex = indexPath.row;
        [self.contentTableView.mj_header beginRefreshing];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MDYTypeInquestionModel *model = self.dataSource[indexPath.row];
        MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
        vc.questionId = model.put_questions_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有问答数据～";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - Getter
- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_listTableView];
        [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.width.mas_equalTo(98);
        }];
        _listTableView.tag = 100;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 98, 4)];
        [view setBackgroundColor:K_WhiteColor];
        [_listTableView setTableHeaderView:view];
        [_listTableView setBackgroundColor:KHexColor(0xFAFAFAFF)];
        [_listTableView setSeparatorColor:KHexColor(0xFAFAFAFF)];
    }
    return _listTableView;
}
- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.left.equalTo(self.listTableView.mas_right);
        }];
        _contentTableView.tag = 101;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 98, 0.01)];
        [view setBackgroundColor:K_WhiteColor];
        [_contentTableView setTableFooterView:[UIView new]];
        [_contentTableView setTableHeaderView:view];
        [_contentTableView setBackgroundColor:K_WhiteColor];
        [_contentTableView setSeparatorColor:K_SeparatorColor];
        _contentTableView.emptyDataSetSource = self;
        _contentTableView.emptyDataSetDelegate = self;
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYAllQuestionTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYAllQuestionTableCell.class)];
    }
    return _contentTableView;
}

@end
