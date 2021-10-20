//
//  MDYShoppingCarTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYShoppingCarTableCell.h"

@interface MDYShoppingCarTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;


@end

@implementation MDYShoppingCarTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setTextColor:K_TextBlackColor];
    [self.moneyLabel setTextColor:K_TextMoneyColor];
    [self.numLabel setTextColor:K_MainColor];
    [self.headerImageView.layer setCornerRadius:6];
    
    self.selectedNum = 1;
    self.selectedButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (IBAction)reduceButtonAction:(UIButton *)sender {
    self.selectedNum --;
    if (self.selectedNum == 0) {
        self.selectedNum = 1;
    }
    self.listModel.num = [NSString stringWithFormat:@"%ld",self.selectedNum];
    if (self.didChangeNum) {
        self.didChangeNum(0);
    }
}
- (IBAction)addButtonAction:(UIButton *)sender {
    self.selectedNum ++;
    self.listModel.num = [NSString stringWithFormat:@"%ld",self.selectedNum];
    if (self.didChangeNum) {
        self.didChangeNum(1);
    }
}
- (IBAction)selectedButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
- (void)setSelectedNum:(NSInteger)selectedNum {
    _selectedNum  =selectedNum;
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",selectedNum]];
}
- (void)setListModel:(MDYShoppingCarListModel *)listModel {
    _listModel = listModel;
    if (listModel) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:listModel.goods_img]];
        self.selectedNum = [listModel.num integerValue];
        [self.titleLabel setText:listModel.goods_name];
        NSString *string = @"免费";
        if ([listModel.price floatValue] > 0) {
            string = [NSString stringWithFormat:@"¥ %.2f",[listModel.price floatValue]];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
            NSRange range = [string rangeOfString:@"¥"];
            if (range.location != NSNotFound) {
                [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
            }
            [self.moneyLabel setAttributedText:attString];
        } else {
            [self.moneyLabel setText:string];
        }
        [self.selectedButton setSelected:[listModel.is_default integerValue] == 1];
    }
}
@end
