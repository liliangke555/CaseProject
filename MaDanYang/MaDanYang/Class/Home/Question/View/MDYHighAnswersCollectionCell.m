//
//  MDYHighAnswersCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYHighAnswersCollectionCell.h"

@interface MDYHighAnswersCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIView *botView;

@end

@implementation MDYHighAnswersCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.botView.layer setCornerRadius:4];
    [self.botView setClipsToBounds:YES];
    self.botView.hidden = YES;
    
    [self setBackgroundColor:K_WhiteColor];
    [self.layer setCornerRadius:6];
    [self.layer setShadowColor:K_ShadowColor.CGColor];
    [self.layer setShadowRadius:10.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.layer setShadowOpacity:1.0f];
    [self setClipsToBounds:YES];
    self.layer.masksToBounds = NO;
    
    [self.titleLabel setTextColor:K_TextBlackColor];
    [self.detailLabel setTextColor:K_TextGrayColor];
    [self.nameLabel setTextColor:K_TextGrayColor];
    [self.headerIamgeView.layer setCornerRadius:16];
    [self.headerIamgeView setContentMode:UIViewContentModeScaleAspectFill];
    [self.answerButton.layer setCornerRadius:4];
    [self.answerButton setClipsToBounds:YES];
    [self.answerButton setBackgroundColor:K_MainColor];
    
    [self.flagView.layer setCornerRadius:4];
    [self.flagView setClipsToBounds:YES];
}
- (IBAction)answerButtonAction:(UIButton *)sender {
    if (self.didClickCheckButton) {
        self.didClickCheckButton();
    }
}
- (void)setCoinNum:(NSInteger)coinNum {
    _coinNum = coinNum;
    NSInteger num = labs(coinNum);
    if (num <= 0) {
        [self.answerButton setTitle:@"  查看回答  " forState:UIControlStateNormal];
    } else {
        NSString *string = [NSString stringWithFormat:@"  %ld积分查看回答  ",num];
        [self.answerButton setTitle:string forState:UIControlStateNormal];
    }
    
}
- (void)setIsNew:(BOOL)isNew {
    _isNew = isNew;
    self.botView.hidden = !isNew;
}
- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [self.headerIamgeView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
}
- (void)setAllModel:(MDYMyQuestionAllModel *)allModel {
    _allModel = allModel;
    if (allModel) {
        self.headerImageUrl = allModel.headimgurl;
        [self.titleLabel setText:allModel.put_title];
        [self.detailLabel setText:allModel.put_txt];
        [self.nameLabel setText:allModel.nickname];
        [self.flagLabel setText:allModel.integral_type_name];
        self.coinNum = allModel.integral_num;
    }
}
- (void)setMyPutModel:(MDYMyQuestionMyPutModel *)myPutModel {
    _myPutModel = myPutModel;
    if (myPutModel) {
        self.headerImageUrl = myPutModel.headimgurl;
        [self.titleLabel setText:myPutModel.put_title];
        [self.detailLabel setText:myPutModel.put_txt];
        [self.nameLabel setText:myPutModel.nickname];
        [self.flagLabel setText:myPutModel.integral_type_name];
        self.coinNum = myPutModel.integral_num;
    }
}
- (void)setMyBuyModel:(MDYMyQuestionMyBuyModel *)myBuyModel {
    _myBuyModel = myBuyModel;
    if (myBuyModel) {
        self.headerImageUrl = myBuyModel.headimgurl;
        [self.titleLabel setText:myBuyModel.put_title];
        [self.detailLabel setText:myBuyModel.put_txt];
        [self.nameLabel setText:myBuyModel.nickname];
        [self.flagLabel setText:myBuyModel.integral_type_name];
        self.coinNum = myBuyModel.integral_num;
    }
}
- (void)setTeacherAnswerModel:(MDYTeacherPutQuestionModel *)teacherAnswerModel {
    _teacherAnswerModel = teacherAnswerModel;
    if (teacherAnswerModel) {
        self.headerImageUrl = teacherAnswerModel.headimgurl;
        [self.titleLabel setText:teacherAnswerModel.put_title];
        [self.detailLabel setText:teacherAnswerModel.put_txt];
        [self.nameLabel setText:teacherAnswerModel.nickname];
        [self.flagLabel setText:teacherAnswerModel.integral_type_name];
        self.coinNum = teacherAnswerModel.integral_num;
    }
}
- (void)setExcellentModel:(MDYExcellentPutQuestionsModel *)excellentModel {
    _excellentModel = excellentModel;
    if (excellentModel) {
        self.headerImageUrl = excellentModel.headimgurl;
        [self.titleLabel setText:excellentModel.put_title];
        [self.detailLabel setText:excellentModel.put_txt];
        [self.nameLabel setText:excellentModel.nickname];
        [self.flagLabel setText:excellentModel.integral_type_name];
        self.coinNum = excellentModel.integral_num;
    }
}
@end
