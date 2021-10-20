//
//  MDYCurriculumListTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYCurriculumListTableCell.h"

@implementation MDYCurriculumListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setTextColor:K_TextGrayColor];
        [self.textLabel setFont:KSystemFont(16)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.textLabel setTextColor:K_TextBlackColor];
        [self setBackgroundColor:K_WhiteColor];
    } else {
        [self.textLabel setTextColor:K_TextGrayColor];
        [self setBackgroundColor:KHexColor(0xFAFAFAFF)];
    }
}

@end
