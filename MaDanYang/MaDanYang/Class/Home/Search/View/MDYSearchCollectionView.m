//
//  MDYSearchCollectionView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import "MDYSearchCollectionView.h"

@implementation MDYSearchCollectionView
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
        [titleLabel setText:@"历史搜索"];
//        self.titleLabel = titleLabel;
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(self.mas_right).mas_offset(-16);
        }];
        [button setTitle:@"清空" forState:UIControlStateNormal];
        [button.titleLabel setFont:KSystemFont(14)];
        [button setTitleColor:K_MainColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"search_delete_icon"] forState:UIControlStateNormal];
//        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    return self;
}
- (void)buttonAction:(UIButton *)sender {
    if (self.didClickDelete) {
        self.didClickDelete();
    }
}
@end
