//
//  MDYLiveMessageTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import "MDYLiveMessageTableCell.h"

@implementation MDYLiveMessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.messageView.layer setCornerRadius:10];
    [self.messageView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
