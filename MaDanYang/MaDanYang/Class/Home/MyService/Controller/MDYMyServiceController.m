//
//  MDYMyServiceController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYMyServiceController.h"
#import "MDYTitleView.h"
#import "MDYPhoneCollectionCell.h"
#import "MDYLeavMessageCollectionCell.h"
#import "MDYMsgRecordController.h"
#import "MDYServiceCustomListRequest.h"
#import "MDYServiceAddCustomerRequest.h"
@interface MDYMyServiceController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *phones;

@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, copy) NSString *detailString;
@end

@implementation MDYMyServiceController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的客服";
    self.sectionTitles = @[@"电话咨询",@"在线咨询"];
    
    [self createView];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadList];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadList];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)createView {
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(10);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"提交留言" forState:UIControlStateNormal];
}
#pragma mark - Networking
- (void)reloadList {
    MDYServiceCustomListRequest *request = [MDYServiceCustomListRequest new];
    request.page = 1;
    request.limit = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        if (response.code == 0) {
            weakSelf.phones = response.data;
        }
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
- (void)addCstomer {
    MDYServiceAddCustomerRequest *request = [MDYServiceAddCustomerRequest new];
    request.name = self.nameString;
    request.phone = self.phoneString;
    request.txt = self.detailString;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MMPopupItemHandler block = ^(NSInteger index){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            NSArray *items = @[MMItemMake(@"确定", MMItemTypeHighlight, block)];
            MMAlertView *alterView = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
                [imageView setImage:[UIImage imageNamed:@"success_icon"]];
            } detail:@"您的留言已经提交！" items:items];
            [alterView show];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark -IBAction
- (void)buttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self addCstomer];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section];
    if ([string isEqualToString:@"电话咨询"]) {
        return CGSizeMake(CK_WIDTH - 32, 54);
    }
    if ([string isEqualToString:@"在线咨询"]) {
        return CGSizeMake(CK_WIDTH, 500);
    }
    return CGSizeMake(CK_WIDTH - 32, 52);
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
        tempHeaderView.subTitle = @"";
        reusableView = tempHeaderView;
    }
    return reusableView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionTitles.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *string = [self.sectionTitles objectAtIndex:section];
    if ([string isEqualToString:@"电话咨询"]) {
        return self.phones.count;
    }
    if ([string isEqualToString:@"在线咨询"]) {
        return 1;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section];
    if ([string isEqualToString:@"电话咨询"]) {
        MDYPhoneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYPhoneCollectionCell.class) forIndexPath:indexPath];
        MDYServiceCustomListModel *model = [self.phones objectAtIndex:indexPath.item];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@：%@",model.name,model.phone]];
        return cell;
    }
    CKWeakify(self);
    MDYLeavMessageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYLeavMessageCollectionCell.class) forIndexPath:indexPath];
    [cell setDidClickRecord:^(UIView * _Nonnull view) {
        MDYMsgRecordController *vc = [[MDYMsgRecordController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell setDidEditName:^(NSString * _Nonnull string) {
        weakSelf.nameString = string;
    }];
    [cell setDidEditPhone:^(NSString * _Nonnull string) {
        weakSelf.phoneString = string;
    }];
    [cell setDidEditDetail:^(NSString * _Nonnull string) {
        weakSelf.detailString = string;
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *string = [self.sectionTitles objectAtIndex:indexPath.section];
    if ([string isEqualToString:@"电话咨询"]) {
        MDYServiceCustomListModel *model = [self.phones objectAtIndex:indexPath.item];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.phone]] options:0 completionHandler:^(BOOL success) {
            
        }];
    }
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 0, 16, 0)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 70, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYPhoneCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYPhoneCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYLeavMessageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYLeavMessageCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
