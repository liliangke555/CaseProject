//
//  MDYChangeGoodsController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYChangeGoodsController.h"
#import "MDYOrderGoodsTableCell.h"
#import "MDYChangeResonTableCell.h"
#import "MDYChangePhotoTableCell.h"
#import "MDYOrderChangeGoodsRequest.h"
#import "MDYUploadImageRequest.h"
@interface MDYChangeGoodsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MDYOrderInfoModel *infoModel;

@property (nonatomic, copy) NSString *textString;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@end

@implementation MDYChangeGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 3;
    self.navigationItem.title = @"申请换货";
    [self createView];
    CKWeakify(self);
    self.tableView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getOrderDetail];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createView {
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, KBottomSafeHeight + 10, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"提交审核" forState:UIControlStateNormal];
}
- (void)pushButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self upload];
}
- (void)refreshView {
    [self.tableView reloadData];
}
#pragma mark - Networking
- (void)getOrderDetail {
    MDYOrderInfoReqeust *request = [MDYOrderInfoReqeust new];
    request.order_num = self.orderNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.infoModel = response.data;
        weakSelf.dataSource = weakSelf.infoModel.order_goods;
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)uploadChangeInfo {
    
    NSString *imageurl=@"";
    if (self.imageUrls.count > 0) {
        imageurl = [self.imageUrls componentsJoinedByString:@","];
    }
    MDYOrderChangeGoodsRequest *request = [MDYOrderChangeGoodsRequest new];
    request.order_num = self.orderNum;
    request.txt = self.textString;
    request.imgs = imageurl;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MDYOrderChangeGoodsSuccess object:nil];
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
- (void)upload {
    if (self.photoSource.count > 0) {
        [MBProgressHUD showLoadingWithMessage:@"上传图片"];
        dispatch_group_t _group = dispatch_group_create();
        for (UIImage *image in self.photoSource) {
            [self uploadImageWithImage:image group:_group];
        }
        CKWeakify(self);
        dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [weakSelf uploadChangeInfo];
        });
    } else {
        [self uploadChangeInfo];
    }
}
- (void)uploadImageWithImage:(UIImage *)image group:(dispatch_group_t)_group {
    MDYUploadImageRequest *request = [MDYUploadImageRequest new];
    NSData *imageData;
    NSString *mimetype;
    if (UIImagePNGRepresentation(image) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(image);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    dispatch_group_enter(_group);
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(_group);
        MDYUploadImageModel *model = response.data;
        [weakSelf.imageUrls addObject:model.url];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(_group);
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        MDYOrderGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderGoodsTableCell.class)];
        MDYOrderInfoGoodsModel *model = self.dataSource[indexPath.row];
        [cell setGoodsModel:model];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        return cell;
    } else if (indexPath.row == self.dataSource.count) {
        MDYChangeResonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYChangeResonTableCell.class)];
        CKWeakify(self);
        [cell setDidEndEditingString:^(NSString * _Nonnull string) {
            weakSelf.textString = string;
        }];
        return cell;
    }
    MDYChangePhotoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYChangePhotoTableCell.class)];
    cell.dataSource = self.photoSource;
    cell.maxPhoto = self.maxPhoto;
    CKWeakify(self);
    [cell setDidClickAdd:^{
        [weakSelf addImage];
    }];
    [cell setDidClickReview:^(NSInteger index) {
        [weakSelf reviewImage:index];
    }];
    [cell setDidClickDelete:^(NSInteger index) {
        [weakSelf.photoSource removeObjectAtIndex:index];
        [weakSelf.selectedAssets removeObjectAtIndex:index];
        [weakSelf.tableView reloadData];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        CGFloat bottomHeight = 49 + 10 + KBottomSafeHeight + 10;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, bottomHeight, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:self.bottomView];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderGoodsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderGoodsTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYChangeResonTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYChangeResonTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYChangePhotoTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYChangePhotoTableCell.class)];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderDetailButtonTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderDetailButtonTableCell.class)];
    }
    return _tableView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, 0, CK_WIDTH, 100);
        
        UILabel *pointLabel = [[UILabel alloc] init];
        [_bottomView addSubview:pointLabel];
        [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView.mas_left).mas_offset(16);
            make.top.equalTo(_bottomView.mas_top).mas_offset(16);
        }];
        [pointLabel setFont:KSystemFont(16)];
        [pointLabel setTextColor:K_TextMoneyColor];
        [pointLabel setText:@"*"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [_bottomView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pointLabel.mas_right);
            make.centerY.equalTo(pointLabel.mas_centerY);
        }];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setText:@"申请换货制度"];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [_bottomView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView.mas_left).mas_offset(16);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(8);
            make.right.equalTo(_bottomView.mas_right).mas_offset(-16);
        }];
        [detailLabel setFont:KSystemFont(14)];
        [detailLabel setTextColor:K_TextGrayColor];
        [detailLabel setText:@"文本配置信息文本配置信息文本配置信息文本配置信息文本配置信息文本配置信息文本配置信息文本配置信息文本配置信息"];
        [detailLabel setNumberOfLines:0];
    }
    return _bottomView;
}
- (NSMutableArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}
@end
