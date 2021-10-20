//
//  MDYBuyGoodsView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MDYBuyGoodsView.h"
@interface MDYBuyGoodsView ()
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneylabel;
@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *reduceButton;
@end

@implementation MDYBuyGoodsView

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
        
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(-6);
            make.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(12);
        }];
        [topView setBackgroundColor:K_WhiteColor];
        [topView.layer setCornerRadius:6];
        [topView setClipsToBounds:YES];
        
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn20115%2F214%2Fw2048h1366%2F20190305%2F9715-htwhfzs2320391.jpg&refer=http%3A%2F%2Fn.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626839103&t=dca7201d45dbc023e391d22b2c625ef7"]];
        [imageView.layer setCornerRadius:6];
        [imageView setClipsToBounds:YES];
        self.headerImageView = imageView;
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
        [titlelabel setText:@"快讯！世卫组织宣布新冠肺炎疫情已具有大流行特征"];
        [titlelabel setNumberOfLines:0];
        self.titleLabel = titlelabel;
        
        UILabel *moneylabel = [[UILabel alloc] init];
        [self addSubview:moneylabel];
        [moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_equalTo(16);
            make.bottom.equalTo(imageView.mas_bottom);
        }];
        [moneylabel setTextColor:K_TextMoneyColor];
        [moneylabel setFont:KMediumFont(16)];
        [moneylabel setText:@"¥ 0.00"];
        self.moneylabel = moneylabel;
        
        UIButton *addbutton = [UIButton k_buttonWithTarget:self action:@selector(addbuttonAction:)];
        [self addSubview:addbutton];
        [addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-16);
            make.centerY.equalTo(moneylabel.mas_centerY);
        }];
        [addbutton setImage:[UIImage imageNamed:@"shop_add_icon"] forState:UIControlStateNormal];
        self.addButton = addbutton;
        
        UILabel *numlabel = [[UILabel alloc] init];
        [self addSubview:numlabel];
        [numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addbutton.mas_left).mas_equalTo(-16);
            make.centerY.equalTo(addbutton.mas_centerY);
        }];
        [numlabel setTextColor:K_MainColor];
        [numlabel setFont:KSystemFont(16)];
        self.numLabel = numlabel;
        self.goodsNum = 1;
        
        UIButton *reducebutton = [UIButton k_buttonWithTarget:self action:@selector(reducebuttonAction:)];
        [self addSubview:reducebutton];
        [reducebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(numlabel.mas_left).mas_offset(-16);
            make.centerY.equalTo(addbutton.mas_centerY);
        }];
        [reducebutton setImage:[UIImage imageNamed:@"shop_reduce_icon"] forState:UIControlStateNormal];
        self.reduceButton = reducebutton;
        
        
        UIButton *button = [UIButton k_redButtonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(32);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(50);
        }];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        lastAttribute = button.mas_bottom;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastAttribute).mas_offset(KBottomSafeHeight);
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
        self.didClickEnter(self.goodsNum);
    }
    [self hide];
}
- (void)reducebuttonAction:(UIButton *)sender {
    if (self.goodsNum == 1) {
        return;
    }
    self.goodsNum --;
}
- (void)addbuttonAction:(UIButton *)sender {
    self.goodsNum ++;
}
#pragma mark - Setter
- (void)setGoodsNum:(NSInteger)goodsNum {
    _goodsNum = goodsNum;
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",goodsNum]];
}
- (void)setGoodsModel:(MDYGoodsDetailModel *)goodsModel {
    _goodsModel = goodsModel;
    if (goodsModel) {
        [self.titleLabel setText:goodsModel.goods_name];
        [self.moneylabel setText:[NSString stringWithFormat:@"¥ %.2f",[goodsModel.price floatValue]]];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_img]];
        self.goodsNum = 1;
    }
}
- (void)setCourseModel:(MDYCourseDetailModel *)courseModel {
    _courseModel = courseModel;
    if (courseModel) {
        [self.titleLabel setText:courseModel.c_name];
        
        if ([courseModel.is_pay integerValue] == 0) {
            [self.moneylabel setText:@"免费"];
        } else {
            if ([courseModel.is_group integerValue] == 1 || [courseModel.is_seckill integerValue] == 1) {
                NSString *string = courseModel.group_price;
                if ([courseModel.is_seckill integerValue] == 1) {
                    string = courseModel.seckill_price;
                }
                NSString *money = [NSString stringWithFormat:@"¥ %@ ",string];
                NSString *originMoney = [NSString stringWithFormat:@"原价 ¥ %@",courseModel.price];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
                NSMutableAttributedString *originAttString = [[NSMutableAttributedString alloc] initWithString:originMoney];
                NSRange range = [money rangeOfString:@"¥"];
                if (range.location != NSNotFound) {
                    [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
                }
                [originAttString addAttribute:NSFontAttributeName value:KSystemFont(12) range:NSMakeRange(0, originMoney.length)];
                [originAttString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, originMoney.length)];
                [originAttString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, originMoney.length)];
                
                [attString appendAttributedString:originAttString];
                [self.moneylabel setAttributedText:attString];
            } else {
                NSString *string = courseModel.price;
                NSString *money = [NSString stringWithFormat:@"¥ %@ ",string];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
                NSRange range = [money rangeOfString:@"¥"];
                if (range.location != NSNotFound) {
                    [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
                }
                [self.moneylabel setAttributedText:attString];
            }
        }
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:courseModel.img]];
        self.addButton.hidden = YES;
        self.reduceButton.hidden = YES;
        self.numLabel.hidden = YES;
    }
}
@end
