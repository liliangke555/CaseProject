//
//  MDYAllQuestionHightView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYAllQuestionHightView.h"

@implementation MDYAllQuestionHightView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:K_WhiteColor];
        
//        UISwitch *selectSwitch = [[UISwitch alloc] init];
//        [self addSubview:selectSwitch];
//        [selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).mas_offset(-16);
//            make.centerY.equalTo(self.mas_centerY);
//        }];
//        [selectSwitch setOnTintColor:K_MainColor];
//        self.selectedSwitch = selectSwitch;
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [button setImage:[UIImage imageNamed:@"switch_normal_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"switch_selected_icon"] forState:UIControlStateSelected];
        self.switchButton = button;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_left).mas_offset(-8);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [titleLabel setText:@"只看优质"];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setFont:KSystemFont(15)];
        
    }
    return self;
}
- (void)setIsHight:(BOOL)isHight {
    _isHight = isHight;
//    self.selectedSwitch.on = isHight;
    self.switchButton.selected = isHight;
}
- (void)buttonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.didSelectedSwitch) {
        self.didSelectedSwitch(sender);
    }
}
@end
