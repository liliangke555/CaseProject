//
//  MDYTitleView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYTitleView.h"

@interface MDYTitleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *subTitleButton;
@end

@implementation MDYTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setFont:KMediumFont(17)];
        self.titleLabel = titleLabel;
        
        
        UIView *view = [[UIView alloc] init];
        [self insertSubview:view atIndex:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(titleLabel).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(6);
        }];
        [view setBackgroundColor:K_MainColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(self.mas_right).mas_offset(-16);
        }];
        [button setTitle:@"查看全部" forState:UIControlStateNormal];
        [button.titleLabel setFont:KSystemFont(14)];
        [button setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"right_more_icon"] forState:UIControlStateNormal];
        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.subTitleButton = button;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}
- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    if (subTitle.length <= 0) {
        self.subTitleButton.hidden = YES;
        return;
    }
    self.subTitleButton.hidden = NO;
    [self.subTitleButton setTitle:subTitle forState:UIControlStateNormal];
}
- (void)buttonAction:(UIButton *)sender {
    if (self.didClickButton) {
        self.didClickButton();
    }
}
@end
