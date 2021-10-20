//
//  MDYGuidanceHeaderTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYGuidanceHeaderTableCell.h"

@interface MDYGuidanceHeaderTableCell ()
@property (weak, nonatomic) IBOutlet UIView *userBackView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MDYGuidanceHeaderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.timeLabel setTextColor:K_TextLightGrayColor];
    [self.nameLabel setTextColor:K_TextBlackColor];
    [self.userImageView.layer setCornerRadius:25];
    [self.userImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.userBackView setBackgroundColor:K_WhiteColor];
    [self.userBackView.layer setCornerRadius:6];
    [self.userBackView.layer setShadowColor:K_ShadowColor.CGColor];
    [self.userBackView.layer setShadowRadius:10.0f];
    [self.userBackView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.userBackView.layer setShadowOpacity:1.0f];
    [self.userBackView setClipsToBounds:YES];
    self.userBackView.layer.masksToBounds = NO;
}
- (void)setDetailModel:(MDYGuidanceDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel) {
        [self.titleLabel setText:detailModel.title];
        [self.nameLabel setText:detailModel.usename];
        [self.timeLabel setText:detailModel.cartime];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.img]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
