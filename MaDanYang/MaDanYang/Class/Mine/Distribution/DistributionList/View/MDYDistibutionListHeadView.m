//
//  MDYDistibutionListHeadView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/12.
//

#import "MDYDistibutionListHeadView.h"

@interface MDYDistibutionListHeadView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;

@end

@implementation MDYDistibutionListHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        
        UIView *searchView = [[UIView alloc] init];
        [self addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).insets(UIEdgeInsetsMake(16, 16, 0, 16));
            make.height.mas_equalTo(34);
        }];
        [searchView setBackgroundColor:KHexColor(0xF5F5F5FF)];
        [searchView.layer setCornerRadius:6];
        [searchView setClipsToBounds:YES];
        
        UIImageView *searchImageView = [[UIImageView alloc] init];
        [searchView addSubview:searchImageView];
        [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchView.mas_left).mas_offset(8);
            make.centerY.equalTo(searchView.mas_centerY);
            make.width.height.mas_equalTo(20);
        }];
        [searchImageView setImage:[UIImage imageNamed:@"search_gray_icon"]];
        
        UITextField *searchText = [[UITextField alloc] init];
        [searchView addSubview:searchText];
        [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchImageView.mas_right).mas_offset(8);
            make.centerY.equalTo(searchView.mas_centerY);
        }];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索" attributes:
            @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                            NSFontAttributeName:KSystemFont(14)
            }];
        searchText.attributedPlaceholder = attrString;
        self.textField = searchText;
        
        UIButton *searchButton = [UIButton k_buttonWithTarget:self action:@selector(searchButtonAction:)];
        [searchView addSubview:searchButton];
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchText.mas_right);
            make.right.equalTo(searchView.mas_right);
            make.centerY.equalTo(searchView.mas_centerY);
            make.width.mas_equalTo(56);
        }];
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton.titleLabel setFont:KSystemFont(14)];
        [searchButton setTitleColor:KHexColor(0x2D82E5FF) forState:UIControlStateNormal];
        
        
        /*UIView *downView = [[UIView alloc] init];
        [self addSubview:downView];
        [downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 12, 16));
            make.height.mas_equalTo(34);
        }];
        [downView setBackgroundColor:KHexColor(0xF5F5F5FF)];
        [downView.layer setCornerRadius:6];
        [downView setClipsToBounds:YES];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        [downView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(downView.mas_left).mas_offset(12);
            make.centerY.equalTo(downView.mas_centerY);
        }];
        [titlelabel setTextColor:K_TextBlackColor];
        [titlelabel setText:@"排序："];
        [titlelabel setFont:KSystemFont(14)];
        
        UIButton *selectedButton = [UIButton k_buttonWithTarget:self action:@selector(selectedButtonAction:)];
        [downView addSubview:selectedButton];
        [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titlelabel.mas_right);
            make.centerY.equalTo(downView.mas_centerY);
            make.right.equalTo(downView.mas_right);
        }];
        [selectedButton setTitle:@"人数高→低" forState:UIControlStateNormal];
        [selectedButton.titleLabel setFont:KSystemFont(14)];
        [selectedButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [selectedButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        self.button = selectedButton;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [selectedButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(selectedButton.mas_right).mas_offset(-12);
            make.centerY.equalTo(selectedButton.mas_centerY);
        }];
        [imageView setImage:[UIImage imageNamed:@"more_down_gray"]];*/
    }
    return self;
}
- (void)searchButtonAction:(UIButton *)sender {
    if (self.didToSearch) {
        self.didToSearch(self.textField.text);
    }
}
- (void)selectedButtonAction:(UIButton *)sender {
    if (self.didSelectedButton) {
        self.didSelectedButton();
    }
}
- (void)setButtonString:(NSString *)buttonString {
    _buttonString = buttonString;
    [self.button setTitle:buttonString forState:UIControlStateNormal];
}
@end
