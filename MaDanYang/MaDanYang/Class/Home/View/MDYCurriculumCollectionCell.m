//
//  MDYCurriculumCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYCurriculumCollectionCell.h"

@interface MDYCurriculumCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;

@end

@implementation MDYCurriculumCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleLabel setTextColor:K_TextBlackColor];
    [self.noteLabel setTextColor:K_TextLightGrayColor];
    [self.moneyLabel setTextColor:K_TextMoneyColor];
    
    [self.imageView.layer setCornerRadius:6];
    [self.imageView setClipsToBounds:YES];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.flagView.hidden = YES;
    self.flagLabel.hidden = YES;
}
- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}
- (void)setMoney:(NSString *)money {
    _money = money;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
    NSRange range = [money rangeOfString:@"￥"];
    if (range.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
    }
    range = [money rangeOfString:@"秒杀价："];
    if (range.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
    }
    range = [money rangeOfString:@"团购价："];
    if (range.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
    }
    [self.moneyLabel setAttributedText:attString];
}
- (void)setNotes:(NSString *)notes {
    _notes = notes;
    [self.noteLabel setText:notes];
}
- (void)setFreeModel:(MDYFreeCourseModel *)freeModel {
    _freeModel = freeModel;
    if (freeModel) {
        self.imageURL = freeModel.img;
        [self.titleLabel setText:freeModel.c_name];
        self.money = @"免费";
        self.notes = freeModel.num;
    }
}
- (void)setExclusiveModel:(MDYHomeExclusiveCourseModel *)exclusiveModel {
    _exclusiveModel = exclusiveModel;
    if (exclusiveModel) {
        self.imageURL = exclusiveModel.img;
        [self.titleLabel setText:exclusiveModel.c_name];
        self.money = exclusiveModel.is_pay;
        NSString *moneyString = @"免费";
        if ([exclusiveModel.is_pay integerValue] == 1) {
            self.noteLabel.hidden = NO;
            moneyString = exclusiveModel.price;
            self.flagView.hidden = YES;
            self.flagLabel.hidden = YES;
        }
        if ([exclusiveModel.is_group integerValue] == 1) {
            self.noteLabel.hidden = YES;
            moneyString = [NSString stringWithFormat:@"团购价：%@",exclusiveModel.group_price];
            self.flagView.hidden = NO;
            self.flagLabel.hidden = NO;
            [self.flagView setImage:[[UIImage imageNamed:@"search_flag_group"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
            [self.flagLabel setText:@"拼团"];
        }
        if ([exclusiveModel.is_seckill integerValue] == 1) {
            self.noteLabel.hidden = YES;
            moneyString = [NSString stringWithFormat:@"秒杀价：%@",exclusiveModel.seckill_price];
            self.flagView.hidden = NO;
            self.flagLabel.hidden = NO;
            [self.flagView setImage:[[UIImage imageNamed:@"search_flag_time"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
            [self.flagLabel setText:@"秒杀"];
        }
        self.money = moneyString;
        self.notes = exclusiveModel.num;
    }
}
- (void)setMallModel:(MDYMallHomeModel *)mallModel {
    _mallModel = mallModel;
    if (mallModel) {
        self.imageURL = mallModel.goods_img;
        [self.titleLabel setText:mallModel.goods_name];
        NSString *moneyString = @"免费";
        if ([mallModel.is_pay integerValue] == 1) {
            self.noteLabel.hidden = NO;
            moneyString = [NSString stringWithFormat:@"¥ %@",mallModel.price];
            self.flagView.hidden = YES;
            self.flagLabel.hidden = YES;
        }
        if ([mallModel.is_group integerValue] == 1) {
            self.noteLabel.hidden = YES;
            moneyString = [NSString stringWithFormat:@"团购价：¥%@",mallModel.group_price];
            self.flagView.hidden = NO;
            self.flagLabel.hidden = NO;
            [self.flagView setImage:[[UIImage imageNamed:@"search_flag_group"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
            [self.flagLabel setText:@"拼团"];
        }
        if ([mallModel.is_seckill integerValue] == 1) {
            self.noteLabel.hidden = YES;
            moneyString = [NSString stringWithFormat:@"秒杀价：¥%@",mallModel.seckill_price];
            self.flagView.hidden = NO;
            self.flagLabel.hidden = NO;
            [self.flagView setImage:[[UIImage imageNamed:@"search_flag_time"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
            [self.flagLabel setText:@"秒杀"];
        }
        self.money = moneyString;
        self.notes = [NSString stringWithFormat:@"%@人已购买",mallModel.num];
    }
}
@end
