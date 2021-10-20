//
//  MDYPlatformCerController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYPlatformCerController.h"
#import "MDYTitleView.h"
#import "MDYPlatformCerCollectionCell.h"
#import "MDYVerificationRequest.h"
#import "MDYUploadImageRequest.h"
@interface MDYPlatformCerController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *imageUrlString;
@end

@implementation MDYPlatformCerController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 1;
    self.navigationItem.title = @"平台认证";
    self.typeString = @"工商营业执照";
    [self.collectionView reloadData];
    [self createView];
}
- (void)createView {
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(10);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(49);
    }];
    if ([kUser.identity integerValue] == 2) {
        [button setTitle:@"正在审核" forState:UIControlStateNormal];
        button.enabled = NO;
    } else if ([kUser.identity integerValue] == 1) {
        [button setTitle:@"已通过" forState:UIControlStateNormal];
        button.enabled = NO;
    } else {
        [button setTitle:@"提交审核" forState:UIControlStateNormal];
        button.enabled = YES;
    }
}
- (void)buttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.nameString.length <= 0) {
        [MBProgressHUD showMessage:@"请输入名称"];
        return;
    }
    if (self.addressString.length <= 0) {
        [MBProgressHUD showMessage:@"请输入地址"];
        return;
    }
    if (self.photoSource.count <= 0) {
        [MBProgressHUD showMessage:@"请选择图片"];
        return;
    }
    [self uploadImageWithImage:self.photoSource[0]];
}
- (void)refreshView {
    [self.collectionView reloadData];
}
#pragma mark - IBAction
- (void)showType {
    CKWeakify(self);
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"证件类型" data:@[@"工商营业执照",@"医疗机构许可证"] didSelected:^(NSInteger index,NSString * _Nonnull string) {
        weakSelf.typeString = string;
    }];
    [view show];
}
#pragma mark - Networking
- (void)uploadDataWithImageUrl:(NSString *)imageUrl {
    MDYVerificationRequest *request = [MDYVerificationRequest new];
    request.enterprise_img = imageUrl;
    request.enterprise_name = self.nameString;
    request.enterprise_add = self.addressString;
    request.enterprise_type = self.typeString;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code != 0) {
            return;
        }
        [MBProgressHUD showSuccessfulWithMessage:response.message];
        MDYUserModel *user = [MDYSingleCache shareSingleCache].userModel;
        MDYUserModel *model = [[MDYUserModel alloc] mj_setKeyValues:[user mj_keyValues]];
        model.enterprise_name = weakSelf.nameString;
        model.enterprise_add = weakSelf.addressString;
        model.enterprise_type = weakSelf.typeString;
        model.enterprise_img = imageUrl;
        model.identity = @"1";
        [MDYSingleCache shareSingleCache].userModel = model;
        [weakSelf.navigationController popViewControllerAnimated:YES];
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
    [MBProgressHUD showLoadingWithMessage:@"图片上传中..."];
    CKWeakify(self);
    request.hideLoadingView = YES;
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(MDYBaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUD];
        MDYUploadImageModel *model = response.data;
        [weakSelf uploadDataWithImageUrl:model.url];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CK_WIDTH, 592);
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
        tempHeaderView.title = @"提交认证信息";
        tempHeaderView.subTitle = @"";
        reusableView = tempHeaderView;
    }
    return reusableView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CKWeakify(self);
    MDYPlatformCerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYPlatformCerCollectionCell.class) forIndexPath:indexPath];
    if ([[MDYSingleCache shareSingleCache].userModel.identity integerValue] != 0) {
        cell.userModel = [MDYSingleCache shareSingleCache].userModel;
    } else {
        if (self.photoSource.count > 0) {
            [cell.imageView setImage:self.photoSource[0]];
            [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        } else {
            [cell.imageView setImage:[UIImage imageNamed:@"upload_big_icon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
        }
    }
    [cell setDidClickChangeType:^{
        [weakSelf showType];
    }];
    [cell setDidClickSelectedImage:^{
        [weakSelf addImage];
    }];
    [cell setDidEndEditName:^(NSString * _Nonnull string) {
        weakSelf.nameString = string;
    }];
    [cell setDidEndEditAddress:^(NSString * _Nonnull string) {
        weakSelf.addressString = string;
    }];
    return cell;
    
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 16, 0)];
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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYPlatformCerCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYPlatformCerCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
