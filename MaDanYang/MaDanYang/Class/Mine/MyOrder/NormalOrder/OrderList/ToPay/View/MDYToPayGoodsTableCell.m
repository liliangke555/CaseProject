//
//  MDYToPayGoodsTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import "MDYToPayGoodsTableCell.h"

@interface MDYToPayGoodsTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *mobeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation MDYToPayGoodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titlelabel setTextColor:K_TextBlackColor];
    [self.numLabel setTextColor:K_MainColor];
    [self.mobeyLabel setTextColor:K_TextMoneyColor];
    [self.headImageView.layer setCornerRadius:6];
    
    self.selectedNum = 1;
}
- (IBAction)reduceButtonAction:(UIButton *)sender {
    self.selectedNum --;
    if (self.selectedNum == 0) {
        self.selectedNum = 1;
    }
    if (self.didChangeNum) {
        self.didChangeNum(self.selectedNum);
    }
}
- (IBAction)assButtonAction:(UIButton *)sender {
    self.selectedNum ++;
    if (self.didChangeNum) {
        self.didChangeNum(self.selectedNum);
    }
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setCourse:(BOOL)course {
    _course = course;
    if (course) {
        self.reduceButton.hidden = YES;
        self.addButton.hidden = YES;
        self.numLabel.hidden = YES;
    } else {
        self.reduceButton.hidden = NO;
        self.addButton.hidden = NO;
        self.numLabel.hidden = NO;
    }
}
- (void)setSelectedNum:(NSInteger)selectedNum {
    _selectedNum  =selectedNum;
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",selectedNum]];
}
- (void)setGoodsModel:(MDYPlaceOrderGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    if (goodsModel) {
        self.imageUrl = goodsModel.goods_img;
        [self.titlelabel setText:goodsModel.goods_name];
        [self.mobeyLabel setText:[NSString stringWithFormat:@"¥ %@",goodsModel.price]];
        self.selectedNum = [goodsModel.goods_num integerValue];
    }
}
- (void)setIntegralGoodModel:(MDYIntergralOrderGoodsModel *)integralGoodModel {
    _integralGoodModel = integralGoodModel;
    if (integralGoodModel) {
        self.imageUrl = integralGoodModel.goods_img;
        [self.titlelabel setText:integralGoodModel.goods_name];
        [self.mobeyLabel setText:[NSString stringWithFormat:@"%@积分",integralGoodModel.price]];
        self.selectedNum = [integralGoodModel.goods_num integerValue];
    }
}
- (void)setCourseModel:(MDYCurriculumDetailModel *)courseModel {
    _courseModel = courseModel;
    if (courseModel) {
        self.imageUrl = courseModel.img;
        [self.titlelabel setText:courseModel.c_name];
        [self.mobeyLabel setText:[NSString stringWithFormat:@"¥ %@",courseModel.price]];
        self.numLabel.hidden = YES;
        self.addButton.hidden = YES;
        self.reduceButton.hidden = YES;
    }
}
- (void)setOrderGoodsModel:(MDYOrderInfoGoodsModel *)orderGoodsModel {
    _orderGoodsModel = orderGoodsModel;
    if (orderGoodsModel) {
        self.imageUrl = orderGoodsModel.goods_img;
        [self.titlelabel setText:orderGoodsModel.goods_name];
        [self.mobeyLabel setText:[NSString stringWithFormat:@"¥ %@",orderGoodsModel.goods_price]];
//        self.numLabel.hidden = YES;
        [self.numLabel setText:orderGoodsModel.goods_num];
        self.addButton.hidden = YES;
        self.reduceButton.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
