//
//  MDYGoodsNameTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MDYGoodsNameTableCell.h"

@interface MDYGoodsNameTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MDYGoodsNameTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDetailModel:(MDYGoodsDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel) {
        [self.nameLabel setText:detailModel.goods_name];
        if ([detailModel.is_pay integerValue] == 0) {
            [self.moneyLabel setText:@"免费"];
        } else {
            if ([detailModel.is_group integerValue] == 1 || [detailModel.is_seckill integerValue] == 1) {
                NSString *string = detailModel.group_price;
                if ([detailModel.is_seckill integerValue] == 1) {
                    string = detailModel.seckill_price;
                }
                NSString *money = [NSString stringWithFormat:@"¥ %@ ",string];
                NSString *originMoney = [NSString stringWithFormat:@"原价 ¥ %@",detailModel.price];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
                NSMutableAttributedString *originAttString = [[NSMutableAttributedString alloc] initWithString:originMoney];
                NSRange range = [money rangeOfString:@"¥"];
                if (range.location != NSNotFound) {
                    [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
                }
                [originAttString addAttribute:NSFontAttributeName value:KSystemFont(12) range:NSMakeRange(0, originMoney.length)];
                [originAttString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, originMoney.length)];
                [originAttString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, originMoney.length)];
                
                [attString appendAttributedString:originAttString];
                [self.moneyLabel setAttributedText:attString];
            } else {
                NSString *money = [NSString stringWithFormat:@"¥ %@ ",detailModel.price];
                NSRange range = [money rangeOfString:@"¥"];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
                if (range.location != NSNotFound) {
                    [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
                }
                [self.moneyLabel setAttributedText:attString];
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
