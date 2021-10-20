//
//  MDYPointsExchangeView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYPointsExchangeView.h"

@interface MDYPointsExchangeView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *button;
@end

@implementation MDYPointsExchangeView

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
        
        UILabel *titlelabel = [[UILabel alloc] init];
        [self addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(backButton.mas_centerY);
        }];
        [titlelabel setTextColor:K_TextBlackColor];
        [titlelabel setFont:KMediumFont(17)];
        [titlelabel setText:@"积分兑换"];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.width.height.mas_equalTo(100);
        }];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farchive%2F92b0189df2f90c87243e28e18ffbaa555a25a8b2.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625642426&t=4ec2a5c02f0b47cb171229533927995d"]];
        [imageView.layer setCornerRadius:6];
        [imageView setClipsToBounds:YES];
        self.imageView = imageView;
        lastAttribute = imageView.mas_bottom;
        
        UILabel *goodsLabel = [[UILabel alloc] init];
        [self addSubview:goodsLabel];
        [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_equalTo(16);
            make.top.equalTo(imageView.mas_top);
            make.right.equalTo(self.mas_right).mas_offset(-10);
        }];
        [goodsLabel setTextColor:K_TextBlackColor];
        [goodsLabel setFont:KSystemFont(16)];
        [goodsLabel setText:@"快讯！世卫组织宣布新冠肺炎疫情已具有大流行特征"];
        [goodsLabel setNumberOfLines:2];
        self.nameLabel = goodsLabel;
        
        UILabel *pointsLabel = [[UILabel alloc] init];
        [self addSubview:pointsLabel];
        [pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView.mas_bottom);
            make.left.equalTo(imageView.mas_right).mas_offset(8);
        }];
        [pointsLabel setText:@"10000 积分"];
        [pointsLabel setTextColor:K_TextMoneyColor];
        [pointsLabel setFont:KMediumFont(16)];
        self.pointLabel = pointsLabel;
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.left.equalTo(self.mas_left).mas_offset(16);
        }];
        [subTitleLabel setText:@"兑换规则"];
        [subTitleLabel setTextColor:K_TextBlackColor];
        [subTitleLabel setFont:KMediumFont(16)];
        lastAttribute = subTitleLabel.mas_bottom;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(8);
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.right.equalTo(self.mas_right).mas_offset(-16);
        }];
        [detailLabel setText:@"斯坦福大学医学教授杰伊·巴特查里亚（Jay Bhattacharya）接受CGTN专访，称研究证明美国已经存在有大量未接受检测的新冠病毒感染者。"];
        [detailLabel setTextColor:K_TextGrayColor];
        [detailLabel setFont:KSystemFont(14)];
        [detailLabel setNumberOfLines:0];
        lastAttribute = detailLabel.mas_bottom;
        
        UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(60);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(50);
        }];
        UIImage *img = [UIImage ck_imageWithColor:KHexColor(0xF37575FF)];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setTitle:@"--积分兑换" forState:UIControlStateNormal];
        self.button = button;
        
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
    if (self.didClickEnter) {
        self.didClickEnter();
    }
    [self hide];
}
#pragma mark - Setter
- (void)setGoodsModel:(MDYIntegralGoodsListModel *)goodsModel {
    _goodsModel = goodsModel;
    if (goodsModel) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_img]];
        [self.nameLabel setText:goodsModel.goods_name];
        [self.pointLabel setText:[NSString stringWithFormat:@"%@ 积分",goodsModel.integral]];
        [self.button setTitle:[NSString stringWithFormat:@"%@积分兑换",goodsModel.integral] forState:UIControlStateNormal];
    }
}
- (void)setCourseModel:(MDYIntegralCourseListModel *)courseModel {
    _courseModel = courseModel;
    if (courseModel) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseModel.img]];
        [self.nameLabel setText:courseModel.c_name];
        [self.pointLabel setText:[NSString stringWithFormat:@"%@ 积分",courseModel.integral]];
        [self.button setTitle:[NSString stringWithFormat:@"%@积分兑换",courseModel.integral] forState:UIControlStateNormal];
    }
}
@end
