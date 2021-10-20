//
//  MDYOrderPayTypeTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import "MDYOrderPayTypeTableCell.h"

@interface MDYOrderPayTypeTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImsageView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

@end

@implementation MDYOrderPayTypeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentBgView.layer setCornerRadius:28];
    [self.contentBgView.layer setBorderWidth:1];
    [self.contentBgView setClipsToBounds:YES];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}
- (void)setSelect:(BOOL)select {
    _select = select;
    if (select) {
        [self.selectedImsageView setImage:[UIImage imageNamed:@"agree_selected"]];
        [self.titleLabel setTextColor:K_MainColor];
        [self.contentBgView.layer setBorderColor:K_MainColor.CGColor];
        if ([self.title isEqualToString:@"微信支付"]) {
            [self.headImageView setImage:[UIImage imageNamed:@"pay_wechat_selected"]];
        } else if ([self.title isEqualToString:@"支付宝"]) {
            [self.headImageView setImage:[UIImage imageNamed:@"pay_ali_selected"]];
        } else {
            [self.headImageView setImage:[UIImage imageNamed:@"pay_offline_selected"]];
        }
    } else {
        [self.contentBgView.layer setBorderColor:KHexColor(0xF3F3F3FF).CGColor];
        [self.selectedImsageView setImage:[UIImage imageNamed:@"selected_normal_icon"]];
        [self.titleLabel setTextColor:K_TextBlackColor];
        if ([self.title isEqualToString:@"微信支付"]) {
            [self.headImageView setImage:[UIImage imageNamed:@"pay_wechat_noraml"]];
        } else if ([self.title isEqualToString:@"支付宝"]) {
            [self.headImageView setImage:[UIImage imageNamed:@"pay_ali_normal"]];
        } else {
            [self.headImageView setImage:[UIImage imageNamed:@"pay_offline_normal"]];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
