//
//  MDYTeacherCollectionViewCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYTeacherCollectionViewCell.h"

@interface MDYTeacherCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numlabel;
@property (weak, nonatomic) IBOutlet UIButton *chenckButton;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;

@end

@implementation MDYTeacherCollectionViewCell

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
    
    [self.numlabel setTextColor:K_TextMoneyColor];
    [self.nameLabel setTextColor:K_TextGrayColor];
    
    [self.headerImageView.layer setCornerRadius:25];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.questionButton.layer setCornerRadius:4];
    [self.questionButton setClipsToBounds:YES];
    [self.questionButton setBackgroundColor:K_MainColor];
    
    [self.chenckButton.layer setCornerRadius:4];
    [self.chenckButton setClipsToBounds:YES];
    [self.chenckButton setBackgroundColor:K_MainColor];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.kawasaki.co.th%2Fuploads%2Fproducts%2F2020-ninja650%2Fgallery-01-full.jpg&refer=http%3A%2F%2Fwww.kawasaki.co.th&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625650713&t=2f926a527a98bab31bbb8a84270eb66a"]];
}
- (IBAction)checkButtonAction:(UIButton *)sender {
    if (self.didCheckBlock) {
        self.didCheckBlock();
    }
}
- (IBAction)questionButtonAction:(UIButton *)sender {
    if (self.didToQuestionBlock) {
        self.didToQuestionBlock();
    }
}
- (void)setTeacherModel:(MDYTeacherListModel *)teacherModel {
    _teacherModel = teacherModel;
    if (teacherModel) {
        self.headerImageUrl = teacherModel.head_portrait;
        [self.nameLabel setText:teacherModel.name];
        [self.numlabel setText:[NSString stringWithFormat:@"问答次数：%@", teacherModel.num]];
        NSInteger num = labs(teacherModel.integral_num);
        if (num > 0) {
            [self.questionButton setTitle:[NSString stringWithFormat:@"  %ld积分提问  ",num] forState:UIControlStateNormal];
        } else {
            [self.questionButton setTitle:@"  提问  " forState:UIControlStateNormal];
        }
    }
}
- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
}
@end
