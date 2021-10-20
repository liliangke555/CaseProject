//
//  MDYPersonalHeadTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYPersonalHeadTableCell.h"

@implementation MDYPersonalHeadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImageView.layer setCornerRadius:25];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
