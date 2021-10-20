//
//  MDYDynamicDetailTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "MDYDynamicDetailTableCell.h"
#import "MDYImageCollectionCell.h"
@interface MDYDynamicDetailTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *userBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

@implementation MDYDynamicDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.timeLabel setTextColor:K_TextLightGrayColor];
    [self.detailLabel setTextColor:K_TextGrayColor];
    [self.nameLabel setTextColor:K_TextBlackColor];
    [self.headerImageView.layer setCornerRadius:25];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.userBackView setBackgroundColor:K_WhiteColor];
    [self.userBackView.layer setCornerRadius:6];
    [self.userBackView.layer setShadowColor:K_ShadowColor.CGColor];
    [self.userBackView.layer setShadowRadius:10.0f];
    [self.userBackView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.userBackView.layer setShadowOpacity:1.0f];
    [self.userBackView setClipsToBounds:YES];
    self.userBackView.layer.masksToBounds = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:8];
    [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 32 - 24) / 4.0f, (CK_WIDTH - 32 - 24) / 4.0f)];
    [flowLayout setSectionHeadersPinToVisibleBounds:NO];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class)];
    self.collectionViewHeight.constant = (CK_WIDTH - 32 - 24) / 2.0f + 8;
    
}
- (void)setDetail:(NSString *)detail {
    _detail = detail;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:detail];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    paragraphStyle.lineHeightMultiple = 1.03;
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    [self.detailLabel setAttributedText:attributedStr];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class) forIndexPath:indexPath];
    cell.imageUrl = self.images[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didReviewImage) {
        self.didReviewImage(self.images,indexPath.item);
    }
}
- (void)setImages:(NSArray *)images {
    _images = images;
    if (images.count <= 0) {
        return;
    }
    [self.headerImageView sd_setImageWithURL:images[0]];
    [self.collectionView reloadData];
}
- (void)setDynamicModel:(MDYHomeDynamicModel *)dynamicModel {
    _dynamicModel = dynamicModel;
    if (dynamicModel) {
        self.detail = dynamicModel.txt?:@"";
        self.images = dynamicModel.imgs;
        [self.nameLabel setText:dynamicModel.nickname];
        [self.timeLabel setText:dynamicModel.car_time];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dynamicModel.headimgurl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
