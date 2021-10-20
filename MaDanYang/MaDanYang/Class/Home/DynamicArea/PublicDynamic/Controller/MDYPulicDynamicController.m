//
//  MDYPulicDynamicController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "MDYPulicDynamicController.h"
#import "MDYImageCollectionCell.h"
#import "MMSheetView.h"
#import "MDYPublicDynamicRequest.h"
#import "MDYUploadImageRequest.h"
@interface MDYPulicDynamicController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageUrls;

@end
NSInteger const maxTextLenght = 500;
NSInteger const maxImages = 6;
@implementation MDYPulicDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 6;
    self.navigationItem.title = @"发晒单";
    [self createView];
}
- (void)createView {
    MASViewAttribute *lastAttribute = self.view.mas_top;
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).mas_offset(24);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(0.5f);
    }];
    [lineView setBackgroundColor:KHexColor(0xDDDDDDFF)];
    
    UITextView *textView = [[UITextView alloc] init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).mas_offset(16);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(145);
    }];
    [textView setTextColor:K_TextBlackColor];
    [textView setFont:KSystemFont(15)];
    textView.delegate = self;
    self.textView = textView;
    
    UILabel *textPlaceholder = [[UILabel alloc] init];
    [textView addSubview:textPlaceholder];
    [textPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_top).mas_offset(8);
        make.left.equalTo(textView.mas_left).mas_offset(5);
    }];
    [textPlaceholder setText:@"请输入心得"];
    [textPlaceholder setTextColor:K_TextGrayColor];
    [textPlaceholder setFont:KSystemFont(15)];
    self.placeholderLabel = textPlaceholder;
    
    UILabel *numLabel = [[UILabel alloc] init];
    [self.view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).mas_offset(-16);
        make.top.equalTo(textView.mas_bottom).mas_offset(16);
    }];
    [numLabel setText:@"0/500"];
    [numLabel setTextColor:K_TextLightGrayColor];
    [numLabel setFont:KSystemFont(12)];
    self.numLabel = numLabel;
    
    UIView *lineView1 = [[UIView alloc] init];
    [self.view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numLabel.mas_bottom).mas_offset(16);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(0.5f);
    }];
    [lineView1 setBackgroundColor:KHexColor(0xDDDDDDFF)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setMinimumInteritemSpacing:8];
    [flowLayout setMinimumLineSpacing:8];
    [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 32 - 24) / 4.0f, (CK_WIDTH - 32 - 24) / 4.0f)];
    [flowLayout setSectionHeadersPinToVisibleBounds:NO];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom).mas_offset(32);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo((CK_WIDTH - 32 - 24) / 2.0f + 8);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class)];
    [collectionView setBackgroundColor:K_WhiteColor];
    self.collectionView = collectionView;
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushBUttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 10 + KBottomSafeHeight, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"发布晒单" forState:UIControlStateNormal];
}
#pragma mark - Networking
- (void)upload {
    if (self.photoSource.count > 0) {
        [MBProgressHUD showLoadingWithMessage:@"上传图片"];
        _group = dispatch_group_create();
        for (UIImage *image in self.photoSource) {
            [self uploadImageWithImage:image];
        }
        CKWeakify(self);
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [weakSelf uploadData];
        });
    } else {
        [self uploadData];
    }
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
    dispatch_group_enter(_group);
    CKWeakify(self);
    request.hideLoadingView = YES;
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
        MDYUploadImageModel *model = response.data;
        [weakSelf.imageUrls addObject:model.url];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)uploadData {
    NSString *imageurl=@"";
    if (self.imageUrls.count > 0) {
        imageurl = [self.imageUrls componentsJoinedByString:@","];
    }
    MDYPublicDynamicRequest *request = [MDYPublicDynamicRequest new];
    request.txt = self.textView.text;
    request.imgs = imageurl;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:response.message];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)pushBUttonAction:(UIButton *)sender {
    [self upload];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
    if (pointLength > maxTextLenght) {
        [textView resignFirstResponder];
        [MBProgressHUD showMessage:@"内容不能大于500个字"];
        return NO;
    }
    [self.numLabel setText:[NSString stringWithFormat:@"%ld/500",pointLength]];
    return YES;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CK_WIDTH - 32 - 24) / 4.0f, (CK_WIDTH - 32 - 24) / 4.0f);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoSource.count >= self.maxPhoto ? self.photoSource.count : self.photoSource.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class) forIndexPath:indexPath];
    if (indexPath.item == self.photoSource.count) {
        cell.imageUrl = @"image_add_icon";
        [cell showDelete:NO deleteAction:nil];
    } else {
        [cell.imageView setImage:self.photoSource[indexPath.item]];
        CKWeakify(self);
        [cell showDelete:YES deleteAction:^{
            [weakSelf.photoSource removeObjectAtIndex:indexPath.item];
            [weakSelf.selectedAssets removeObjectAtIndex:indexPath.item];
            [weakSelf.collectionView reloadData];
        }];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.photoSource.count) {
        [self addImage];
    } else {
        [self reviewImage:indexPath.item];
    }
}
- (void)refreshView {
    [self.collectionView reloadData];
}
- (NSMutableArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}
@end
