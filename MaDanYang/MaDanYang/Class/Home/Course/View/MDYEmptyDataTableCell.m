//
//  MDYEmptyDataTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/9/16.
//

#import "MDYEmptyDataTableCell.h"

@interface MDYEmptyDataTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MDYEmptyDataTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setTextColor:K_TextLightGrayColor];
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    [self.titleLabel setText:titleString];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
