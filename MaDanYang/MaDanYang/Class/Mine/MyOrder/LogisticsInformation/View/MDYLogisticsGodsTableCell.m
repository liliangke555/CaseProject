//
//  MDYLogisticsGodsTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYLogisticsGodsTableCell.h"

@implementation MDYLogisticsGodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImageView.layer setCornerRadius:6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
