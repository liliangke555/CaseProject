//
//  MDYFillOrderNumberController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import "MDYFillOrderNumberController.h"
#import "MDYOrderGoodsTableCell.h"
#import "MDYChangePhotoTableCell.h"
#import "MDYInputInfoTableCell.h"
#import "MDYUploadImageRequest.h"
#import "MDYOrderChangeGoodsWaybillRequest.h"
@interface MDYFillOrderNumberController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MDYOrderInfoModel *infoModel;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) NSString *companyString;
@property (nonatomic, copy) NSString *waybillString;
@end

@implementation MDYFillOrderNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"填写快递信息";
    self.maxPhoto = 1;
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
    [button setTitle:@"提交快递信息" forState:UIControlStateNormal];
}
- (void)pushButtonAction:(UIButton *)sender {
    if (self.photoSource.count > 0) {
        [self uploadImageWithImage:self.photoSource[0]];
    } else {
        [self uploadWaybillWithImage:@""];
    }
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
- (void)uploadWaybillWithImage:(NSString *)imageUrl {
    MDYOrderChangeGoodsWaybillRequest *request = [MDYOrderChangeGoodsWaybillRequest new];
    request.img_t = imageUrl;
    request.num_t = self.waybillString;
    request.order_num = self.orderNum;
    request.name_t = self.companyString;
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
- (void)uploadImageWithImage:(UIImage *)image {
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
    request.hideLoadingView = YES;
    [MBProgressHUD showLoadingWithMessage:@"上传图片"];
    CKWeakify(self);
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
        MDYUploadImageModel *model = response.data;
        [weakSelf uploadWaybillWithImage:model.url];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        MDYOrderGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYOrderGoodsTableCell.class)];
        MDYOrderInfoGoodsModel *model = self.dataSource[indexPath.row];
        [cell setGoodsModel:model];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        return cell;
    } else if (indexPath.row == self.dataSource.count) {
        MDYInputInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYInputInfoTableCell.class)];
        cell.title = @"快递公司";
        CKWeakify(self);
        [cell setDidEndEditingString:^(NSString * _Nonnull string) {
            weakSelf.companyString = string;
        }];
        return cell;
    } else if (indexPath.row == self.dataSource.count + 1) {
        MDYInputInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYInputInfoTableCell.class)];
        cell.title = @"快递单号";
        CKWeakify(self);
        [cell setDidEndEditingString:^(NSString * _Nonnull string) {
            weakSelf.waybillString = string;
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
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 8)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_SeparatorColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderGoodsTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderGoodsTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYInputInfoTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYInputInfoTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYChangePhotoTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYChangePhotoTableCell.class)];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYOrderDetailButtonTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYOrderDetailButtonTableCell.class)];
    }
    return _tableView;
}
@end
