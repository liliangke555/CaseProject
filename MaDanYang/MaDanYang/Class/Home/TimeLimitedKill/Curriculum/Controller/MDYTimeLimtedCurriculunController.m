//
//  MDYTimeLimtedCurriculunController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MDYTimeLimtedCurriculunController.h"
#import "MDYSearchResultTableCell.h"
#import "MDYCourseDetailController.h"
#import "MDYCurriculumSeckillReqeust.h"
#import "MDYGoodsTimeKillRequest.h"
#import "MDYGoodsDetailsController.h"
@interface MDYTimeLimtedCurriculunController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) NSMutableArray *timeLabels;
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MDYTimeLimtedCurriculunController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //判断页面是pop到上个界面还是push到下个界面
    NSArray *viewControllers = self.navigationController.viewControllers;
    if(viewControllers.count > 1 && [[viewControllers objectAtIndex:viewControllers.count-2] isKindOfClass:NSClassFromString(@"MDYTimeLImitedController")]) {
    //push到下个界面，不销毁也不停止NSTimer
    }else{
        //pop到上个界面，销毁停止NSTimer
        if(_timer != nil){
            [_timer invalidate];
            _timer = nil;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    self.timeLabels = [NSMutableArray array];
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        if (weakSelf.index == 0) {
            [weakSelf getCurriculumListData];
        } else {
            [weakSelf getListData];
        }
    }];
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.index == 0) {
            [weakSelf getCurriculumListData];
        } else {
            [weakSelf getListData];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIView *timeView = [[UIView alloc] init];
    [self.view addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view).insets(UIEdgeInsetsMake(16, 16, 0, 16));
        make.height.mas_equalTo(58);
    }];
    [timeView setBackgroundColor:K_WhiteColor];
    [timeView.layer setCornerRadius:6];
    [timeView.layer setShadowColor:K_ShadowColor.CGColor];
    [timeView.layer setShadowRadius:10.0f];
    [timeView.layer setShadowOffset:CGSizeMake(0, 2)];
    [timeView.layer setShadowOpacity:1.0f];
    [timeView setClipsToBounds:YES];
    timeView.layer.masksToBounds = NO;
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [timeView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeView.mas_left).mas_offset(12);
        make.centerY.equalTo(timeView.mas_centerY);
    }];
    [titlelabel setText:@"距离结束时间"];
    [titlelabel setTextColor:K_TextBlackColor];
    [titlelabel setFont:KSystemFont(14)];
    
    __block UIView *fristView = nil;
    __block UIView *lastView = nil;
    for (int i = 0 ; i < 3; i ++) {
        UIView *view = [[UIView alloc] init];
        [timeView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!fristView) {
                make.right.equalTo(timeView.mas_right).mas_offset(-12);
                fristView = view;
            } else {
                make.right.equalTo(lastView.mas_left).mas_offset(-22);
            }
            make.centerY.equalTo(timeView.mas_centerY);
            make.width.height.mas_equalTo(26);
        }];
        [view setBackgroundColor:K_TextRedColor];
        [view.layer setCornerRadius:4];
        lastView = view;
        
        UILabel *timelabel = [[UILabel alloc] init];
        [timeView addSubview:timelabel];
        [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        [timelabel setText:@"00"];
        [timelabel setTextColor:K_WhiteColor];
        [timelabel setFont:KSystemFont(13)];
        [self.timeLabels addObject:timelabel];
        if (i != 2) {
            UILabel *label = [[UILabel alloc] init];
            [timeView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_left).mas_offset(-8);
                make.centerY.equalTo(timeView.mas_centerY);
            }];
            [label setText:@":"];
            [label setTextColor:K_TextBlackColor];
            [label setFont:KSystemFont(16)];
        }
        
    }
    self.timeLabels = (NSMutableArray *)[[self.timeLabels reverseObjectEnumerator] allObjects];
}
- (void)timerAction {
    if (self.countDownTime <= 0 && _timer) {
        [_timer invalidate];
        _timer = nil;
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    NSTimeInterval time = self.countDownTime;
    NSDate *myDate= [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *firstDate = [NSDate date];
    NSString *firstDateStr = [dateFomatter stringFromDate:firstDate];
    NSString *afterDateStr = [dateFomatter stringFromDate:myDate];
    NSDate *afterDate = [dateFomatter dateFromString:afterDateStr];
    
    // 当前时间data格式
    firstDate = [dateFomatter dateFromString:firstDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差        先是 早的时间      后是 晚的时间
    NSDateComponents *dateCom = [calendar components:unit fromDate:firstDate toDate:afterDate options:0];
    UILabel *label = self.timeLabels[0];
    [label setText:[NSString stringWithFormat:@"%02ld",dateCom.day * 24 + dateCom.hour]];
    UILabel *label1 = self.timeLabels[1];
    [label1 setText:[NSString stringWithFormat:@"%02ld",dateCom.minute]];
    UILabel *label2 = self.timeLabels[2];
    [label2 setText:[NSString stringWithFormat:@"%02ld",dateCom.second]];
}
#pragma mark - Networking
- (void)getCurriculumListData {
    MDYCurriculumSeckillReqeust *request = [MDYCurriculumSeckillReqeust new];
    request.page = self.pageNum;
    request.limit = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
            if (weakSelf.dataSource.count > 0) {
                MDYCurriculumSeckillModel *model = weakSelf.dataSource[0];
                weakSelf.countDownTime = [model.end_time integerValue];
//                if (weakSelf.refreshCountDownTime) {
//                    weakSelf.refreshCountDownTime(weakSelf.countDownTime);
//                }
            }
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        if (self.dataSource.count >= response.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)getListData {
    MDYGoodsTimeKillRequest *request = [MDYGoodsTimeKillRequest new];
    request.page = 1;
    request.limit = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
            if (weakSelf.dataSource.count > 0) {
                MDYGoodsTimeKillModel *model = weakSelf.dataSource[0];
                weakSelf.countDownTime = [model.end_time integerValue];
//                if (weakSelf.refreshCountDownTime) {
//                    weakSelf.refreshCountDownTime([model.end_time integerValue]);
//                }
            }
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        if (self.dataSource.count >= response.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 124;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYSearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    if (self.index == 0) {
        MDYCurriculumSeckillModel *model = self.dataSource[indexPath.row];
        [cell setSourseKillModel:model];
    } else {
        MDYGoodsTimeKillModel *model = self.dataSource[indexPath.row];
        [cell setTimeModel:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.index == 0) {
        MDYCurriculumSeckillModel *model = self.dataSource[indexPath.row];
        MDYCourseDetailController *vc = [[MDYCourseDetailController alloc] init];
        vc.courseId = model.uid;
        vc.courseType = 1;
        vc.seckillId = model.seckill_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MDYAllGoodsModel *model = self.dataSource[indexPath.row];
        MDYGoodsDetailsController *vc = [[MDYGoodsDetailsController alloc] init];
        vc.goodsId = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"活动未开始～";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (void)setCountDownTime:(NSInteger)countDownTime {
    _countDownTime = countDownTime;
    if (countDownTime > 0 && !_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(98, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.1)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchResultTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    }
    return _tableView;
}
@end
