//
//  MDYLiveRoomLockView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYLiveRoomLockView.h"

@interface MDYLiveRoomLockView ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation MDYLiveRoomLockView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = K_WhiteColor;
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        UIButton *backButton = [UIButton mm_buttonWithTarget:self action:@selector(backAction:)];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(16);
            make.left.equalTo(self.mas_left).mas_offset(16);
        }];
        [backButton setTitle:@"  返回" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [backButton.titleLabel setFont:KSystemFont(16)];
        lastAttribute = backButton.mas_bottom;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.width.height.mas_equalTo(100);
        }];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView.layer setCornerRadius:6];
        [imageView setClipsToBounds:YES];
        self.bigImageView = imageView;
        lastAttribute = imageView.mas_bottom;
        
        UILabel *titlelabel = [[UILabel alloc] init];
        [self addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_equalTo(16);
            make.top.equalTo(imageView.mas_top);
            make.right.equalTo(self.mas_right).mas_offset(-10);
        }];
        [titlelabel setTextColor:K_TextBlackColor];
        [titlelabel setFont:KSystemFont(16)];
        [titlelabel setText:@"---"];
        self.titleLabel = titlelabel;
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [self addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_offset(16);
            make.bottom.equalTo(imageView.mas_bottom);
            make.width.height.mas_equalTo(32);
        }];
        [headerImageView.layer setCornerRadius:16];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [headerImageView setClipsToBounds:YES];
        self.headerImageView = headerImageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView.mas_centerY);
            make.left.equalTo(headerImageView.mas_right).mas_offset(8);
        }];
        [nameLabel setText:@"--"];
        [nameLabel setTextColor:K_TextGrayColor];
        [nameLabel setFont:KSystemFont(14)];
        self.nameLabel = nameLabel;
        
        UILabel *codelabel = [[UILabel alloc] init];
        [self addSubview:codelabel];
        [codelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.left.equalTo(self.mas_left).mas_offset(16);
        }];
        [codelabel setText:@"邀请码"];
        [codelabel setTextColor:K_TextBlackColor];
        [codelabel setFont:KSystemFont(16)];
        lastAttribute = codelabel.mas_bottom;
        
        UITextField *textField = [[UITextField alloc] init];
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(16);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(20);
        }];
        [textField setPlaceholder:@"请输入邀请码"];
        [textField setFont:KSystemFont(14)];
        [textField setTextColor:K_TextBlackColor];
        lastAttribute = textField.mas_bottom;
        self.textField = textField;
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textField.mas_bottom).mas_offset(16);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(1);
        }];
        [lineView setBackgroundColor:KHexColor(0xDDDDDDFF)];
        
        UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).mas_offset(24);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(50);
        }];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_bottom).mas_offset(KBottomSafeHeight);
        }];
    }
    return self;
}
#pragma mark - IBAction
- (void)backAction:(UIButton *)sender {
    [self hide];
}
- (void)buttonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.didClickEnter) {
        self.didClickEnter(self.textField.text);
    }
    [self hide];
}
#pragma mark - Setter
- (void)setModel:(MDYObsLiveListModel *)model {
    _model = model;
    if (model) {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        [self.titleLabel setText:model.live_title];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.head_portrait] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
        [self.nameLabel setText:model.name];
    }
}
@end
