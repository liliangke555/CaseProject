//
//  MDYAllQuestionTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYAllQuestionTableCell.h"

@interface MDYAllQuestionTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *detaillabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@end

@implementation MDYAllQuestionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titlelabel setTextColor:K_TextBlackColor];
    [self.detaillabel setTextColor:K_TextGrayColor];
    [self.nameLabel setTextColor:K_TextGrayColor];
    [self.headerImageView.layer setCornerRadius:16];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.checkButton.layer setCornerRadius:4];
    [self.checkButton setClipsToBounds:YES];
    [self.checkButton setBackgroundColor:K_MainColor];
    
    [self setSeparatorInset:UIEdgeInsetsZero];
}
- (IBAction)checkButtonAction:(UIButton *)sender {
    if (self.didToCheckAnswer) {
        self.didToCheckAnswer();
    }
}
- (void)setIsHight:(BOOL)isHight {
    _isHight = isHight;
    if (isHight) {
        [self.checkButton setTitle:@"  10积分查看回答  " forState:UIControlStateNormal];
    } else {
        [self.checkButton setTitle:@"  查看回答  " forState:UIControlStateNormal];
    }
}
- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
}
- (void)setQuestionModel:(MDYTypeInquestionModel *)questionModel {
    _questionModel = questionModel;
    if (questionModel) {
        [self.titlelabel setText:questionModel.put_title];
        [self.detaillabel setText:questionModel.put_txt];
        [self.nameLabel setText:questionModel.nickname];
        self.headerImageUrl = questionModel.headimgurl;
        NSInteger num = labs(questionModel.integral_num);
        if (num > 0) {
            [self.checkButton setTitle:[NSString stringWithFormat:@"  %ld积分查看回答  ",num] forState:UIControlStateNormal];
        } else {
            [self.checkButton setTitle:@"  查看回答  " forState:UIControlStateNormal];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
