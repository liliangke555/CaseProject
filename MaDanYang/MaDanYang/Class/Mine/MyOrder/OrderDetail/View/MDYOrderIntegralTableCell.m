//
//  MDYOrderIntegralTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYOrderIntegralTableCell.h"

@interface MDYOrderIntegralTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

@end

@implementation MDYOrderIntegralTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
    [self.contentBgView setBackgroundColor:K_WhiteColor];
    [self.contentBgView.layer setCornerRadius:6];
    [self.contentBgView.layer setShadowColor:K_ShadowColor.CGColor];
    [self.contentBgView.layer setShadowRadius:8.0f];
    [self.contentBgView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.contentBgView.layer setShadowOpacity:1.0f];
    [self.contentBgView setClipsToBounds:YES];
    self.contentBgView.layer.masksToBounds = NO;
}
- (void)setIntegral:(NSString *)integral {
    _integral = integral;
    if (integral.length > 0) {
        NSString *string = [NSString stringWithFormat:@"该订单获得%@积分",integral];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = [string rangeOfString:integral];
        if (range.location != NSNotFound) {
            [attString addAttribute:NSForegroundColorAttributeName value:K_TextMoneyColor range:range];
        }
        [self.titleLabel setAttributedText:attString];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
