//
//  MDYHomeDynamicCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYHomeDynamicCollectionCell.h"
#import "MDYImageCollectionCell.h"
@interface MDYHomeDynamicCollectionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *notelabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIView *maskBackView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation MDYHomeDynamicCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headerImageView.layer setCornerRadius:20];
    [self.headerImageView setClipsToBounds:YES];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.nameLabel setTextColor:K_TextBlackColor];
    [self.timeLabel setTextColor:K_TextLightGrayColor];
    [self.notelabel setTextColor:K_TextGrayColor];
    
    [self setBackgroundColor:K_WhiteColor];
    [self.layer setCornerRadius:6];
    [self.layer setShadowColor:K_ShadowColor.CGColor];
    [self.layer setShadowRadius:10.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.layer setShadowOpacity:1.0f];
    [self setClipsToBounds:YES];
    self.layer.masksToBounds = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:8];
    [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 32 - 24 - 24) / 4.0f, (CK_WIDTH - 32 - 24 - 24) / 4.0f)];
    [flowLayout setSectionHeadersPinToVisibleBounds:NO];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class)];
    [self.collectionView reloadData];
    
    [self.checkButton.layer setCornerRadius:4];
    [self.checkButton setClipsToBounds:YES];
    [self.checkButton setBackgroundColor:K_MainColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectV = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectV.alpha = 0.95;
    [self.maskBackView insertSubview:effectV atIndex:0];
    [effectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.maskBackView).with.insets(UIEdgeInsetsZero);
    }];
    [self.maskBackView.layer setCornerRadius:6];
    [self.maskBackView setClipsToBounds:YES];
}
- (IBAction)checkButtonAction:(UIButton *)sender {
    if (self.didClickCheck) {
        self.didClickCheck();
    }
//    self.exhibition = YES;
}
- (void)setExhibition:(BOOL)exhibition {
    _exhibition = exhibition;
    if (exhibition) {
        self.maskBackView.hidden = YES;
        self.checkButton.hidden = YES;
    } else {
        self.maskBackView.hidden = NO;
        self.checkButton.hidden = NO;
    }
}
- (void)setIntegralNum:(NSInteger)integralNum {
    _integralNum = integralNum;
    if (integralNum > 0) {
        self.exhibition = NO;
        [self.checkButton setTitle:[NSString stringWithFormat:@"  %ld积分查看  ",integralNum] forState:UIControlStateNormal];
    } else {
        self.exhibition = YES;
    }
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count > 4 ? 4 : self.images.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class) forIndexPath:indexPath];
    cell.imageUrl = self.images[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didCheckImage) {
        self.didCheckImage(indexPath.item);
    }
}
- (void)setDetail:(NSString *)detail {
    _detail = detail;
    CGFloat height = [detail getLabelHeightWithWidth:CK_WIDTH - 32 - 24 font:14];
    _cellHeight  += height > 51 ? 51 : height;
    [self.notelabel setText:detail];
}
- (void)setName:(NSString *)name {
    _name = name;
    [self.nameLabel setText:name];
}
- (void)setTime:(NSString *)time {
    _time = time;
    [self.timeLabel setText:time];
}
- (void)setHeaderImage:(NSString *)headerImage {
    _headerImage = headerImage;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
}
- (void)setImages:(NSArray *)images {
    _images = images;
    if (images.count > 0) {
        _cellHeight += (CK_WIDTH - 32 - 24 - 24) / 4.0f;
        self.collectionViewHeight.constant = (CK_WIDTH - 32 - 24 - 24) / 4.0f;
        [self.collectionView reloadData];
    } else {
        self.collectionViewHeight.constant = 0;
    }
}
@end
