//
//  MDYPointsMallGoodsTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYPointsMallGoodsTableCell.h"

@interface MDYPointsMallGoodsTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
@implementation MDYPointsMallGoodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bigImageView.layer setCornerRadius:6];
    [self.bigImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.titleLabel setTextColor:K_TextBlackColor];
    [self.moneyLabel setTextColor:K_TextMoneyColor];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setMoney:(NSString *)money {
    _money = money;
    NSString *title = @"积分";
    NSString *strign = [NSString stringWithFormat:@"%@ %@",money,title];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strign];
    NSRange range = [strign rangeOfString:title];
    if (range.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
    }
    [self.moneyLabel setAttributedText:attString];
}
- (void)setGoodsModel:(MDYIntegralGoodsListModel *)goodsModel {
    _goodsModel = goodsModel;
    if (goodsModel) {
        [self.titleLabel setText:goodsModel.goods_name];
        self.money = goodsModel.integral;
        self.imageUrl = goodsModel.goods_img;
    }
}
- (void)setCourseModel:(MDYIntegralCourseListModel *)courseModel {
    _courseModel = courseModel;
    if (courseModel) {
        [self.titleLabel setText:courseModel.c_name];
        self.money = courseModel.integral;
        self.imageUrl = courseModel.img;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
