//
//  MDYOrderGoodsTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYOrderGoodsTableCell.h"

@interface MDYOrderGoodsTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabe;

@end

@implementation MDYOrderGoodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
    [self.headImageView.layer setCornerRadius:6];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setGoodsModel:(MDYOrderInfoGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    if (goodsModel) {
        self.imageUrl = goodsModel.goods_img;
        [self.titleLabel setText:goodsModel.goods_name];
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥ %@",goodsModel.goods_price]];
        [self.numLabe setText:[NSString stringWithFormat:@"X %@",goodsModel.goods_num]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
