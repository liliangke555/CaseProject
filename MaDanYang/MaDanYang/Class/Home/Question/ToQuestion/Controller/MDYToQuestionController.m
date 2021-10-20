//
//  MDYToQuestionController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYToQuestionController.h"
#import "MDYImageCollectionCell.h"
#import "MDYPutQuestionRequest.h"
#import "MDYPutQuestionTypeReqeust.h"
#import "MDYUploadImageRequest.h"
#import "MDYAddPutQuestionRequest.h"
@interface MDYToQuestionController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *pushButton;

@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextView *contentText;
@property (nonatomic, strong) UIButton *typeButton;
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, assign) NSInteger selectedTypeIndex;

@property (nonatomic, strong) NSMutableArray *imageUrls;
@end

NSInteger const maxTitleLenght = 10;
NSInteger const maxLenght = 300;
@implementation MDYToQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 3;
    self.selectedTypeIndex = -1;
    if (self.isToTeacher) {
        self.navigationItem.title = @"我要提问";
    } else {
        self.navigationItem.title = @"提问";
    }
    [self createView];
}
- (void)showPickerViewWithType:(NSArray *)array {
    CKWeakify(self);
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"积分类型" data:array didSelected:^(NSInteger index ,NSString * _Nonnull string) {
        weakSelf.selectedTypeIndex = index;
        [weakSelf.typeButton setTitle:string forState:UIControlStateNormal];
    }];
    [view show];
}
#pragma mark - Networking
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
    NSString *integralId = @"";
    if (self.selectedTypeIndex < self.typeArray.count) {
        MDYPutQuestionTypeModel *model = self.typeArray[self.selectedTypeIndex];
        integralId = model.integral_type_id;
    }
    NSString *imageurl=@"";
    if (self.imageUrls.count > 0) {
        imageurl = [self.imageUrls componentsJoinedByString:@","];
    }
    MDYPutQuestionRequest *request = [MDYPutQuestionRequest new];
    request.put_title = self.titleTextField.text;
    request.put_txt = self.contentText.text;
    request.integral_type_id = integralId;
    request.imgs = imageurl;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
    
}
- (void)getQeustionTypeData {
    MDYPutQuestionTypeReqeust *request = [MDYPutQuestionTypeReqeust new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        weakSelf.typeArray = response.data;
        if (weakSelf.typeArray.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (MDYPutQuestionTypeModel *model in weakSelf.typeArray) {
                [array addObject:model.type_name];
            }
            [weakSelf showPickerViewWithType:array];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)putToTeacherQuestion {
    NSString *integralId = @"";
    if (self.selectedTypeIndex < self.typeArray.count) {
        MDYPutQuestionTypeModel *model = self.typeArray[self.selectedTypeIndex];
        integralId = model.integral_type_id;
    }
    NSString *imageurl=@"";
    if (self.imageUrls.count > 0) {
        imageurl = [self.imageUrls componentsJoinedByString:@","];
    }
    MDYAddPutQuestionRequest *request = [MDYAddPutQuestionRequest new];
    request.admin_id = self.teacherModel.admin_id;
    request.put_title = self.titleTextField.text;
    request.put_txt = self.contentText.text;
    request.integral_type_id = integralId;
    request.imgs = imageurl;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
#pragma mark - SetupView
- (void)createView {
    MASViewAttribute *lastAttribute = self.view.mas_top;
    if (self.isToTeacher) {
        UIView *view = [[UIView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(16);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(82);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:6];
        [view.layer setShadowColor:K_ShadowColor.CGColor];
        [view.layer setShadowRadius:10.0f];
        [view.layer setShadowOffset:CGSizeMake(0, 2)];
        [view.layer setShadowOpacity:1.0f];
        [view setClipsToBounds:YES];
        view.layer.masksToBounds = NO;
        lastAttribute = view.mas_bottom;
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [view addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).mas_offset(12);
            make.width.height.mas_equalTo(50);
        }];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [headerImageView.layer setCornerRadius:25];
        [headerImageView setClipsToBounds:YES];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.teacherModel.head_portrait]];
        
        UILabel *noteLabel = [[UILabel alloc] init];
        [self.view addSubview:noteLabel];
        [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).mas_offset(16);
            make.centerY.equalTo(headerImageView.mas_centerY);
        }];
        [noteLabel setTextColor:K_TextBlackColor];
        [noteLabel setFont:KMediumFont(14)];
        NSString *string = [NSString stringWithFormat:@"向@%@老师提问",self.teacherModel.name];
        NSRange range = [string rangeOfString:[NSString stringWithFormat:@"@%@老师",self.teacherModel.name]];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        if (range.location != NSNotFound) {
            [attrString addAttribute:NSForegroundColorAttributeName value:K_MainColor range:range];
        }
        [noteLabel setAttributedText:attrString];
    }
    
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).mas_offset(16);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        make.height.mas_equalTo(56);
    }];
    [textField setFont:KMediumFont(17)];
    [textField setTextColor:K_TextBlackColor];
    NSAttributedString *passAttrString = [[NSAttributedString alloc] initWithString:@"请输入标题" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KMediumFont(17)
        }];
    textField.attributedPlaceholder = passAttrString;
    textField.delegate = self;
    self.titleTextField = textField;
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
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
    self.contentText = textView;
    
    UILabel *textPlaceholder = [[UILabel alloc] init];
    [textView addSubview:textPlaceholder];
    [textPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_top).mas_offset(8);
        make.left.equalTo(textView.mas_left).mas_offset(5);
    }];
    [textPlaceholder setText:@"提问内容"];
    [textPlaceholder setTextColor:K_TextGrayColor];
    [textPlaceholder setFont:KSystemFont(15)];
    self.placeholderLabel = textPlaceholder;
    
    UIButton *typeButton = [UIButton k_buttonWithTarget:self action:@selector(typeButtonAction:)];
    [self.view addSubview:typeButton];
    [typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_offset(16);
        make.top.equalTo(textView.mas_bottom).mas_offset(16);
    }];
    [typeButton.titleLabel setFont:KSystemFont(14)];
    [typeButton setTitle:@"请选择积分类型  " forState:UIControlStateNormal];
    [typeButton setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"more_down_gray"] forState:UIControlStateNormal];
    [typeButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    self.typeButton = typeButton;
    
    UILabel *numLabel = [[UILabel alloc] init];
    [self.view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).mas_offset(-16);
        make.top.equalTo(textView.mas_bottom).mas_offset(16);
    }];
    [numLabel setText:@"0/300"];
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
        make.height.mas_equalTo((CK_WIDTH - 32 - 24) / 4.0f);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class)];
    [collectionView setBackgroundColor:K_WhiteColor];
    self.collectionView = collectionView;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_offset(16);
        make.top.equalTo(collectionView.mas_bottom).mas_offset(16);
    }];
    [noteLabel setText:@"*每次提问将扣除xx积分"];
    [noteLabel setTextColor:K_TextMoneyColor];
    [noteLabel setFont:KSystemFont(12)];
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushBUttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 10 + KBottomSafeHeight, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"发布提问" forState:UIControlStateNormal];
}
- (void)refreshView {
    [self.collectionView reloadData];
}
#pragma mark IBAction
- (void)pushBUttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.titleTextField.text.length <= 0) {
        [MBProgressHUD showMessage:@"请输入标题"];
        return;
    }
    if (self.contentText.text.length <= 0) {
        [MBProgressHUD showMessage:@"请输入详情内容"];
        return;
    }
    if (self.selectedTypeIndex == -1) {
        [MBProgressHUD showMessage:@"请选择类型"];
        return;
    }
    
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
        } else {
            [weakSelf upload];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
        [imageView setImage:[UIImage imageNamed:@"pay_alter_icon"]];
    } detail:@"确认花费10积分来提问问题么？" items:items];
    [view show];
}
- (void)upload {
    if (self.photoSource.count > 0) {
        _group = dispatch_group_create();
        [MBProgressHUD showLoadingWithMessage:@"图片上传中..."];
        for (UIImage *image in self.photoSource) {
            [self uploadImageWithImage:image];
        }
        CKWeakify(self);
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [weakSelf uploadData];
        });
    } else {
        if (self.isToTeacher) {
            [self putToTeacherQuestion];
        } else {
            [self uploadData];
        }
    }
}
- (void)typeButtonAction:(UIButton *)sender {
    [self getQeustionTypeData];
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
    if (pointLength > maxLenght) {
        [textView resignFirstResponder];
        [MBProgressHUD showMessage:@"内容不能大于300个字"];
        return NO;
    }
    [self.numLabel setText:[NSString stringWithFormat:@"%ld/300",pointLength]];
    return YES;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > maxTitleLenght) {
        [textField resignFirstResponder];
        [MBProgressHUD showMessage:@"标题不能大于10个字"];
        return NO;
    }
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

#pragma mark - Getter
- (NSMutableArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}
#pragma mark - Setter
- (void)setTeacherModel:(MDYTeacherListModel *)teacherModel {
    _teacherModel = teacherModel;
    if (teacherModel) {
        self.isToTeacher = YES;
    }
}
@end
