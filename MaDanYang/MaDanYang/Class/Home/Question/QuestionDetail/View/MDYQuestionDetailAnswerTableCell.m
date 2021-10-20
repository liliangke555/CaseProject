//
//  MDYQuestionDetailAnswerTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYQuestionDetailAnswerTableCell.h"
#import "MDYImageCollectionCell.h"
@interface MDYQuestionDetailAnswerTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *answerBackView;
@property (weak, nonatomic) IBOutlet UIImageView *answerHeader;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *toQuestionButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *maskBackView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskBackViewTop;

@end

@implementation MDYQuestionDetailAnswerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.timeLabel setTextColor:K_TextLightGrayColor];
    [self.detailLabel setTextColor:K_TextGrayColor];
    [self.nameLabel setTextColor:K_TextBlackColor];
    [self.answerHeader.layer setCornerRadius:25];
    [self.answerHeader setContentMode:UIViewContentModeScaleAspectFill];
    [self.toQuestionButton.layer setCornerRadius:4];
    [self.toQuestionButton setClipsToBounds:YES];
    [self.toQuestionButton setBackgroundColor:K_MainColor];
    
    [self.answerBackView setBackgroundColor:K_WhiteColor];
    [self.answerBackView.layer setCornerRadius:6];
    [self.answerBackView.layer setShadowColor:K_ShadowColor.CGColor];
    [self.answerBackView.layer setShadowRadius:10.0f];
    [self.answerBackView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.answerBackView.layer setShadowOpacity:1.0f];
    [self.answerBackView setClipsToBounds:YES];
    self.answerBackView.layer.masksToBounds = NO;
    
    [self.checkButton.layer setCornerRadius:4];
    [self.checkButton setClipsToBounds:YES];
    [self.checkButton setBackgroundColor:K_MainColor];
    
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
    self.collectionViewHeight.constant = (CK_WIDTH - 32 - 24) / 4.0f;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectV = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectV.alpha = 1;
    [self.maskBackView insertSubview:effectV atIndex:0];
    [effectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.maskBackView).with.insets(UIEdgeInsetsZero);
    }];
}
- (IBAction)checkButtonAction:(UIButton *)sender {
//    self.checkButton.hidden= YES;
//    self.maskBackView.hidden = YES;
    if (self.didCheckAnswer) {
        self.didCheckAnswer();
    }
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
    if (self.didCheckAnswerImage) {
        self.didCheckAnswerImage(indexPath.item, self.images, collectionView);
    }
}
- (IBAction)toQuestionAction:(UIButton *)sender {
    if (self.didToQuestion) {
        self.didToQuestion();
    }
}
- (void)setImages:(NSArray *)images {
    _images = images;
    if (images.count <= 0) {
        return;
    }
    [self.answerHeader sd_setImageWithURL:images[0]];
    [self.collectionView reloadData];
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
- (void)setInfoModel:(MDYPutQuestionInfoModel *)infoModel {
    _infoModel = infoModel;
    if (infoModel) {
        if (infoModel.headimgurl.length > 0 || infoModel.nickname.length > 0) {
            NSInteger num = labs(infoModel.integral_num);
            if (num <= 0) {
                self.detail = infoModel.admin_txt?:@"";
                self.images = infoModel.admin_img;
                self.checkButton.hidden= YES;
                self.maskBackView.hidden = YES;
            } else {
                self.checkButton.enabled = YES;
                
                [self.checkButton setTitle:[NSString stringWithFormat:@" %ld积分查看回答 ",num] forState:UIControlStateNormal];
                [self.checkButton setTitleColor:K_WhiteColor forState:UIControlStateNormal];
                [self.checkButton setBackgroundColor:K_MainColor];
                self.checkButton.hidden = NO;
                self.maskBackView.hidden = NO;
                self.maskBackViewTop.constant = 16+82;
            }
            [self.answerHeader sd_setImageWithURL:[NSURL URLWithString:infoModel.headimgurl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
            [self.nameLabel setText:infoModel.nickname];
            [self.timeLabel setText:infoModel.admin_car_time];
        } else {
            self.checkButton.enabled = NO;
            [self.checkButton setTitle:@" 等待老师回答... " forState:UIControlStateNormal];
            [self.checkButton setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
            [self.checkButton setBackgroundColor:[UIColor clearColor]];
            self.checkButton.hidden = NO;
            self.maskBackView.hidden = NO;
            self.maskBackViewTop.constant = 16;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
