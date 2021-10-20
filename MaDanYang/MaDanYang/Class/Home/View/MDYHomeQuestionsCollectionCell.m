//
//  MDYHomeQuestionsCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYHomeQuestionsCollectionCell.h"

@interface MDYHomeQuestionsCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation MDYHomeQuestionsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    [self.headerImageView.layer setCornerRadius:16];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerImageView setClipsToBounds:YES];
    [self.checkButton.layer setCornerRadius:4];
    [self.checkButton setClipsToBounds:YES];
    [self.checkButton setBackgroundColor:K_MainColor];
}
- (IBAction)toChanckAnswer:(UIButton *)sender {
    if (self.didToCheckAnswer) {
        self.didToCheckAnswer();
    }
}
- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
}
- (void)setHomeQuestionModel:(MDYHomeQuestionModel *)homeQuestionModel {
    _homeQuestionModel = homeQuestionModel;
    if (homeQuestionModel) {
        if (homeQuestionModel.headimgurl.length > 0) {
            self.headerImageUrl = homeQuestionModel.headimgurl;
            self.headerImageView.hidden = NO;
        } else {
            self.headerImageView.hidden = YES;
        }
        if (homeQuestionModel.nickname.length > 0) {
            self.nameLabel.hidden = NO;
            [self.nameLabel setText:homeQuestionModel.nickname];
        } else {
            self.nameLabel.hidden = YES;
        }
        
        [self.titleLabel setText:homeQuestionModel.put_title];
        [self.detailLabel setText:homeQuestionModel.put_txt];
        NSInteger num = labs(homeQuestionModel.integral_num);
        if (num > 0) {
            [self.checkButton setTitle:[NSString stringWithFormat:@"  %ld积分查看回答  ",(long)num] forState:UIControlStateNormal];
        } else {
            [self.checkButton setTitle:@"  查看回答  " forState:UIControlStateNormal];
        }
    }
}
- (void)setAnswerModel:(MDYQuestionAnswerAreaModel *)answerModel {
    _answerModel = answerModel;
    if (answerModel) {
        if (answerModel.headimgurl.length > 0) {
            self.headerImageUrl = answerModel.headimgurl;
            self.headerImageView.hidden = NO;
        } else {
            self.headerImageView.hidden = YES;
        }
        if (answerModel.nickname.length > 0) {
            self.nameLabel.hidden = NO;
            [self.nameLabel setText:answerModel.nickname];
        } else {
            self.nameLabel.hidden = YES;
        }
        
        [self.titleLabel setText:answerModel.put_title];
        [self.detailLabel setText:answerModel.put_txt];
        NSInteger num = labs(answerModel.integral_num);
        if (num > 0) {
            [self.checkButton setTitle:[NSString stringWithFormat:@"  %ld积分查看回答  ",(long)num] forState:UIControlStateNormal];
        } else {
            [self.checkButton setTitle:@"  查看回答  " forState:UIControlStateNormal];
        }
    }
}
@end
