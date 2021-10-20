//
//  MDYPointsMallController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYPointsMallController.h"
#import "MDYCurriculumListTableCell.h"
#import "MDYPointsMallGoodsTableCell.h"
#import "MDYPointsExchangeView.h"
#import "MDYIntegralGoodsTypeRequest.h"
#import "MDYIntegralGoodsListRequest.h"
#import "MDYCourseTypeRequest.h"
#import "MDYIntegralCourseListReqeust.h"
#import "MDYPointPlaceOrderController.h"
#import "MDYOrderEstablishRequest.h"
@interface MDYPointsMallController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UILabel *typelabel;

@property (nonatomic, assign) NSInteger typeIndex;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MDYPointsMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"积分商城";
    self.listData = [NSMutableArray array];
    self.selectedIndex = 0;
    self.dataSource = [NSMutableArray array];
    [self createView];
    [self getGoodsType];
    CKWeakify(self);
    self.contentTableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        if (weakSelf.typeIndex == 0) {
            MDYIntegralGoodsTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
            [weakSelf getGoodsListWithId:model];
        } else {
            MDYCourseTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
            [weakSelf getCourseListWithId:model];
        }
    }];
    self.contentTableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.typeIndex == 0) {
            MDYIntegralGoodsTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
            [weakSelf getGoodsListWithId:model];
        } else {
            MDYCourseTypeModel *model = weakSelf.listData[weakSelf.selectedIndex];
            [weakSelf getCourseListWithId:model];
        }
    }];
}
- (void)createView {
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view).insets(UIEdgeInsetsMake(16, 0, 0, 16));
        make.left.equalTo(self.listTableView.mas_right).mas_offset(12);
        make.height.mas_equalTo(38);
    }];
    [view setBackgroundColor:KHexColor(0xF5F5F5FF)];
    [view.layer setCornerRadius:6];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeButtonAction:)]];
    
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).mas_offset(12);
    }];
    [label setText:@"商品"];
    [label setTextColor:K_TextBlackColor];
    [label setFont:KSystemFont(14)];
    self.typelabel = label;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).mas_offset(-12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [imageView setImage:[UIImage imageNamed:@"more_down_gray"]];
}
#pragma mark - Networking
- (void)getGoodsType {
    MDYIntegralGoodsTypeRequest *request = [MDYIntegralGoodsTypeRequest new];
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
- (void)getCourseType {
    MDYCourseTypeRequest *request = [MDYCourseTypeRequest new];
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
- (void)getGoodsListWithId:(MDYIntegralGoodsTypeModel *)model {
    MDYIntegralGoodsListRequest *request = [MDYIntegralGoodsListRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.type_id = model.type_id;
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
- (void)getCourseListWithId:(MDYCourseTypeModel *)model {
    MDYIntegralCourseListReqeust *request = [MDYIntegralCourseListReqeust new];
    request.page = self.pageNum;
    request.limit = 20;
    request.type_id = model.uid;
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
- (void)exchangeCourseWithId:(NSString *)courseId {
    MDYOrderEstablishRequest *request = [MDYOrderEstablishRequest new];
    request.curriculum_id = courseId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"兑换成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)typeButtonAction:(UITapGestureRecognizer *)sender {
    CKWeakify(self);
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"" data:@[@"商品",@"课程"] didSelected:^(NSInteger index,NSString * _Nonnull string) {
        weakSelf.selectedIndex = 0;
        [weakSelf.typelabel setText:string];
        weakSelf.typeIndex = index;
        if (index == 0) {
            [weakSelf getGoodsType];
        } else {
            [weakSelf getCourseType];
        }
    }];
    [view show];
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
        if (self.typeIndex == 0) {
            MDYIntegralGoodsTypeModel *model = self.listData[indexPath.row];
            [cell.textLabel setText:model.type_name];
        } else {
            MDYCourseTypeModel *model = self.listData[indexPath.row];
            [cell.textLabel setText:model.name];
        }
        return cell;
    } else {
        MDYPointsMallGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYPointsMallGoodsTableCell.class)];
        if (self.typeIndex == 0) {
            MDYIntegralGoodsListModel *model = self.dataSource[indexPath.row];
            [cell setGoodsModel:model];
        } else {
            MDYIntegralCourseListModel *model = self.dataSource[indexPath.row];
            [cell setCourseModel:model];
        }
        
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
        MDYPointsExchangeView *view = [[MDYPointsExchangeView alloc] init];
        if (self.typeIndex == 0) {
            MDYIntegralGoodsListModel *model = self.dataSource[indexPath.row];
            [view setGoodsModel:model];
        } else {
            MDYIntegralCourseListModel *model = self.dataSource[indexPath.row];
            [view setCourseModel:model];
        }
        CKWeakify(self);
        [view setDidClickEnter:^{
            NSString *goodId = @"";
            if (weakSelf.typeIndex == 0) {
                MDYIntegralGoodsListModel *model = weakSelf.dataSource[indexPath.row];
                goodId = model.goods_id;
                
                MDYPointPlaceOrderController *vc = [MDYPointPlaceOrderController new];
                vc.goodId = goodId;
                vc.goods = weakSelf.typeIndex == 0;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                MDYIntegralCourseListModel *model = weakSelf.dataSource[indexPath.row];
                goodId = model.uid;
                [weakSelf exchangeCourseWithId:goodId];
            }
        }];
        [view show];
    }
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
            make.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(16+38+8, 0, 0, 0));
            make.left.equalTo(self.listTableView.mas_right);
        }];
        [_contentTableView setRowHeight:124];
        _contentTableView.tag = 101;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 98, 4)];
        [view setBackgroundColor:K_WhiteColor];
        [_contentTableView setTableHeaderView:view];
        [_contentTableView setBackgroundColor:K_WhiteColor];
        [_contentTableView setSeparatorColor:K_WhiteColor];
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYPointsMallGoodsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYPointsMallGoodsTableCell.class)];
    }
    return _contentTableView;
}
@end
