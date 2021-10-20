//
//  MDYShopBottomView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYShopBottomView.h"

@interface MDYShopBottomView ()
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UIButton *selectedAllButton;
@end

@implementation MDYShopBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        
        UIButton *selectedAll = [UIButton k_buttonWithTarget:self action:@selector(selectedAllAction:)];
        [self addSubview:selectedAll];
        [selectedAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.centerY.equalTo(self.mas_centerY);
//            make.width.mas_equalTo(70);
        }];
        [selectedAll setTitle:@" 全选" forState:UIControlStateNormal];
        [selectedAll setImage:[UIImage imageNamed:@"agree_normal"] forState:UIControlStateNormal];
        [selectedAll setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateSelected];
        [selectedAll setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
        [selectedAll.titleLabel setFont:KSystemFont(14)];
        self.selectedAllButton = selectedAll;
        
        UILabel *allLabel = [[UILabel alloc] init];
        [self addSubview:allLabel];
        [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectedAll.mas_right).mas_offset(16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [allLabel setFont:KMediumFont(16)];
        [allLabel setTextColor:K_TextMoneyColor];
        [allLabel setText:@"合计：¥ 0.00"];
        self.allLabel = allLabel;
        
        UIButton *toPayButton = [UIButton k_buttonWithTarget:self action:@selector(toPayButtonAction:)];
        [self addSubview:toPayButton];
        [toPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-16);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(120);
        }];
        [toPayButton setBackgroundColor:K_TextMoneyColor];
        [toPayButton setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [toPayButton.titleLabel setFont:KMediumFont(16)];
        [toPayButton setTitle:@"去结算" forState:UIControlStateNormal];
        [toPayButton.layer setCornerRadius:4];
        [toPayButton setClipsToBounds:YES];
    }
    return self;
}
- (void)selectedAllAction:(UIButton *)sender {
    self.selectedAll = !sender.isSelected;
    if (self.didSelectedAll) {
        self.didSelectedAll(self.selectedAll);
    }
}
- (void)toPayButtonAction:(UIButton *)sender {
    if (self.toPayAction) {
        self.toPayAction();
    }
}
- (void)setArray:(NSArray *)array {
    _array = array;
    CGFloat money = 0;
    for (MDYShoppingCarListModel *model in array) {
        money += [model.num integerValue] * [model.price floatValue];
    }
    [self.allLabel setText:[NSString stringWithFormat:@"合计：¥ %.2f",money]];
}
- (void)setAllMoney:(CGFloat)allMoney {
    _allMoney = allMoney;
    [self.allLabel setText:[NSString stringWithFormat:@"合计：¥ %.2f",allMoney]];
}
- (void)setSelectedAll:(BOOL)selectedAll {
    _selectedAll = selectedAll;
    [self.selectedAllButton setSelected:selectedAll];
}
@end
