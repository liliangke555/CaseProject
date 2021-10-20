//
//  MDYAllCurriculumController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYAllCurriculumController.h"
#import "MDYCurriculumListTableCell.h"
#import "MDYSearchResultTableCell.h"
#import "MDYCourseDetailController.h"
#import "MDYAllCourseTypeRequest.h"
#import "MDYAllCourseRequest.h"
#import "MDYExclusiveTypeRequest.h"
#import "MDYExclusiveTypeCourseRequest.h"
@interface MDYAllCurriculumController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MDYAllCurriculumController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listData = [NSMutableArray array];
    
    self.pageNum  = 1;
    self.selectedIndex = 0;
    if (self.isExclusive) {
        [self getExclusiveType];
    } else {
        [self getTypeData];
    }
    
    CKWeakify(self);
    self.contentTableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        if (weakSelf.listData.count > 0) {
            MDYFreeCurriculumTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
            if (weakSelf.isExclusive) {
                [weakSelf getExlusiveWithId:model];
            } else {
                [weakSelf getAllCourseWithId:model];
            }
        } else {
            [weakSelf.contentTableView.mj_header endRefreshing];
        }
    }];
    self.contentTableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.listData.count > 0) {
            MDYFreeCurriculumTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
            if (weakSelf.isExclusive) {
                [weakSelf getExlusiveWithId:model];
            } else {
                [weakSelf getAllCourseWithId:model];
            }
        }
    }];
}
- (void)getTypeData {
    MDYAllCourseTypeRequest *request = [MDYAllCourseTypeRequest new];
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
- (void)getExclusiveType {
    MDYExclusiveTypeRequest *request = [MDYExclusiveTypeRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            weakSelf.listData = [NSMutableArray arrayWithArray:response.data];
            [weakSelf.listTableView reloadData];
            NSInteger selectedIndex = 0;
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [weakSelf.listTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [weakSelf.contentTableView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)getAllCourseWithId:(MDYFreeCurriculumTypeModel *)typeModel {
    MDYAllCourseRequest *request = [MDYAllCourseRequest new];
    request.type_id = typeModel.uid;
    request.page = self.pageNum;
    request.limit = 20;
    request.hideLoadingView = YES;
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
- (void)getExlusiveWithId:(MDYFreeCurriculumTypeModel *)model {
    MDYExclusiveTypeCourseRequest *request = [MDYExclusiveTypeCourseRequest new];
    request.type_id = model.uid;
    request.page = self.pageNum;
    request.limit = 20;
    request.hideLoadingView = YES;
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
        }
        MDYFreeCurriculumTypeModel *model = self.listData[indexPath.row];
        [cell.textLabel setText:model.name];
        return cell;
    } else {
        MDYSearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
        MDYAllCourseModel *model = self.dataSource[indexPath.row];
        cell.exlusiveCourse = self.isExclusive;
        [cell setAllCourseModel:model];
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
        MDYAllCourseModel *model = self.dataSource[indexPath.row];
        MDYCourseDetailController *vc = [[MDYCourseDetailController alloc] init];
        vc.courseId = model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"当前还没有课程";
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
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.left.equalTo(self.listTableView.mas_right);
        }];
//        [_contentTableView setRowHeight:124];
        _contentTableView.tag = 101;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 98, 4)];
        [view setBackgroundColor:K_WhiteColor];
        [_contentTableView setTableHeaderView:view];
        [_contentTableView setBackgroundColor:K_WhiteColor];
        [_contentTableView setSeparatorColor:K_WhiteColor];
        _contentTableView.emptyDataSetSource = self;
        _contentTableView.emptyDataSetDelegate = self;
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchResultTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    }
    return _contentTableView;
}

@end
