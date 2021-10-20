//
//  MDYGroupManDetailTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/9/17.
//

#import "MDYGroupManDetailTableCell.h"

@interface MDYGroupManDetailTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation MDYGroupManDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.oneImageView.layer setCornerRadius:20];
    [self.twoImageView.layer setCornerRadius:20];
    
    [self.noteLabel setTextColor:K_TextMoneyColor];
}
- (void)setManModels:(NSArray *)manModels {
    _manModels = manModels;
    NSString *nameString = @"";
    if (manModels.count > 0) {
        MDYGroupOrderManModel *manModel = manModels[0];
        nameString = manModel.head_nickname;
        [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:manModel.head_member_img]];
        if (manModels.count > 1) {
            MDYGroupOrderManModel *manModel = manModels[1];
            nameString = [NSString stringWithFormat:@"%@、%@",nameString,manModel.head_nickname];
            [self.twoImageView sd_setImageWithURL:[NSURL URLWithString:manModel.head_member_img]];
        }
    }
    [self.nameLabel setText:nameString];
}
- (void)setNum:(NSString *)num {
    _num = num;
    if ([num integerValue] <= 0) {
        self.noteLabel.hidden = YES;
        return;
    }
    self.noteLabel.hidden = NO;
    [self.noteLabel setText:[NSString stringWithFormat:@"差%@人成拼",num]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
