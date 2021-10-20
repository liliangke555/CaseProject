//
//  MDYEditQuestionController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/19.
//

#import "MDYEditQuestionController.h"
#import "MDYImageCollectionCell.h"
@interface MDYEditQuestionController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *pushButton;

@end

@implementation MDYEditQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maxPhoto = 3;
    self.navigationItem.title = @"修改问题";
    [self createView];
}
- (void)createView {
    MASViewAttribute *lastAttribute = self.view.mas_top;
    
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
    
    UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushBUttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 10 + KBottomSafeHeight, 16));
        make.height.mas_equalTo(49);
    }];
    [button setTitle:@"保存提问" forState:UIControlStateNormal];
}
- (void)refreshView {
    [self.collectionView reloadData];
}
#pragma mark IBAction
- (void)pushBUttonAction:(UIButton *)sender {
    
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
    if (pointLength > 300) {
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
    if (pointLength > 10) {
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

@end
