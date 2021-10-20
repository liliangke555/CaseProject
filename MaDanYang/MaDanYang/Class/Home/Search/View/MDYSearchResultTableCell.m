//
//  MDYSearchResultTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import "MDYSearchResultTableCell.h"

@interface MDYSearchResultTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@end

@implementation MDYSearchResultTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bigImageView.layer setCornerRadius:6];
    [self.bigImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.titleLabel setTextColor:K_TextBlackColor];
    [self.moneyLabel setTextColor:K_TextMoneyColor];
    [self.noteLabel setTextColor:K_TextLightGrayColor];
    [self.notesLabel setTextColor:K_TextLightGrayColor];
    [self.notesLabel setHidden:YES];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setType:(MDYCurriculumType)type {
    _type = type;
    [self.flagImageView setHidden:NO];
    [self.flagLabel setHidden:NO];
    if (type == MDYCurriculumTypeOfNormal) {
        [self.flagImageView setHidden:YES];
        [self.flagLabel setHidden:YES];
    } else if (type == MDYCurriculumTypeOfGroup) {
        [self.flagImageView setImage:[[UIImage imageNamed:@"search_flag_group"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
        [self.flagLabel setText:@"拼团"];
    } else {
        [self.flagImageView setImage:[[UIImage imageNamed:@"search_flag_time"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
        [self.flagLabel setText:@"秒杀"];
    }
}
- (void)setMoney:(NSString *)money {
    _money = money;
    NSString *title = @"";
    if (self.type == MDYCurriculumTypeOfNormal) {
        title = @"";
    } else if (self.type == MDYCurriculumTypeOfGroup) {
        title = @"拼团价：";
    } else {
        title = @"秒杀价：";
    }
    
    NSString *strign = [NSString stringWithFormat:@"%@%@",title,money];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strign];
    NSRange range = [strign rangeOfString:title];
    if (range.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
    }
    NSRange range1 = [strign rangeOfString:@"￥"];
    if (range1.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range1];
    }
    [self.moneyLabel setAttributedText:attString];
}
- (void)setHiddenNote:(BOOL)hiddenNote {
    _hiddenNote = hiddenNote;
    [self.noteLabel setHidden:hiddenNote];
}
- (void)setNoteString:(NSString *)noteString {
    _noteString = noteString;
    [self.noteLabel setText:noteString];
}

- (void)setCourseModel:(MDYFreeCourseModel *)courseModel {
    _courseModel = courseModel;
    if (courseModel) {
        [self.titleLabel setText:courseModel.c_name];
        [self.noteLabel setText:[NSString stringWithFormat:@"%@人已学习",courseModel.num]];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:courseModel.img]];
        if ([courseModel.is_pay integerValue] == 0) {
            self.money = @"免费";
        }
        self.type = 0;
    }
}

- (void)setAllCourseModel:(MDYAllCourseModel *)allCourseModel {
    _allCourseModel = allCourseModel;
    if (allCourseModel) {
        self.notesLabel.hidden = YES;
        [self.titleLabel setText:allCourseModel.c_name];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:allCourseModel.img]];
        if ([allCourseModel.is_seckill integerValue] == 1) {
            self.noteLabel.hidden = YES;
            self.type = MDYCurriculumTypeOfTime;
            self.money = allCourseModel.seckill_price;
        } else if ([allCourseModel.is_group integerValue] == 1) {
            self.noteLabel.hidden = YES;
            self.type = MDYCurriculumTypeOfGroup;
            self.money = allCourseModel.group_price;
        } else {
            [self.noteLabel setText:allCourseModel.num];
            [self.notesLabel setText:allCourseModel.num];
            self.type = 0;
            if ([allCourseModel.is_pay integerValue] == 0) {
                self.money = @"免费";
                self.noteLabel.hidden = NO;
                self.notesLabel.hidden = YES;
            } else {
                self.notesLabel.hidden = NO;
                self.noteLabel.hidden = YES;
                self.money = allCourseModel.price;
            }
        }
        if (self.isExlusiveCourse) {
            self.notesLabel.hidden = YES;
            self.noteLabel.hidden = YES;
        }
    }
}
- (void)setCourseGoodsModel:(MDYCourseGoodsModel *)courseGoodsModel {
    _courseGoodsModel = courseGoodsModel;
    if (courseGoodsModel) {
        [self.titleLabel setText:courseGoodsModel.goods_name];
        self.noteLabel.hidden = YES;
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:courseGoodsModel.goods_img]];
        if ([courseGoodsModel.is_seckill integerValue] == 1) {
            self.type = MDYCurriculumTypeOfTime;
            self.money = courseGoodsModel.seckill_price;
        } else if ([courseGoodsModel.is_group integerValue] == 1) {
            self.type = MDYCurriculumTypeOfGroup;
            self.money = courseGoodsModel.group_price;
        } else {
            self.type = 0;
            if ([courseGoodsModel.is_pay integerValue] == 0) {
                self.money = @"免费";
            } else {
                self.money = courseGoodsModel.price;
            }
        }
    }
}
- (void)setAllGoodsModel:(MDYAllGoodsModel *)allGoodsModel {
    _allGoodsModel = allGoodsModel;
    if (allGoodsModel) {
        [self.titleLabel setText:allGoodsModel.goods_name];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:allGoodsModel.goods_img]];
        if ([allGoodsModel.is_seckill integerValue] == 1) {
            self.noteLabel.hidden = YES;
            self.type = MDYCurriculumTypeOfTime;
            self.money = allGoodsModel.seckill_price;
        } else if ([allGoodsModel.is_group integerValue] == 1) {
            self.noteLabel.hidden = YES;
            self.type = MDYCurriculumTypeOfGroup;
            self.money = allGoodsModel.group_price;
        } else {
            
            self.type = 0;
            if ([allGoodsModel.is_pay integerValue] == 0) {
                self.noteLabel.hidden = NO;
                self.money = @"免费";
                [self.noteLabel setText:[NSString stringWithFormat:@"%@人已购买",allGoodsModel.num]];
            } else {
                self.noteLabel.hidden = YES;
                self.money = [NSString stringWithFormat:@"¥ %@",allGoodsModel.price];
            }
        }
    }
}
- (void)setTimeModel:(MDYGoodsTimeKillModel *)timeModel {
    _timeModel = timeModel;
    if (timeModel) {
        [self.titleLabel setText:timeModel.goods_name];
        self.noteLabel.hidden = YES;
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:timeModel.goods_img]];
        if ([timeModel.is_seckill integerValue] == 1) {
            self.type = MDYCurriculumTypeOfTime;
            self.money = timeModel.seckill_price;
        } else if ([timeModel.is_group integerValue] == 1) {
            self.type = MDYCurriculumTypeOfGroup;
            self.money = timeModel.group_price;
        } else {
            self.type = 0;
            if ([timeModel.is_pay integerValue] == 0) {
                self.money = @"免费";
            } else {
                self.money = timeModel.price;
            }
        }
        self.noteLabel.hidden = NO;
        [self.noteLabel setText:[NSString stringWithFormat:@"%@人已购买",timeModel.num]];
    }
}
- (void)setSourseKillModel:(MDYCurriculumSeckillModel *)sourseKillModel {
    _sourseKillModel = sourseKillModel;
    if (sourseKillModel) {
        [self.titleLabel setText:sourseKillModel.c_name];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:sourseKillModel.img]];
        if ([sourseKillModel.is_seckill integerValue] == 1) {
            self.noteLabel.hidden = NO;
            [self.noteLabel setText:[NSString stringWithFormat:@"%@人已学习",sourseKillModel.num]];
            self.type = MDYCurriculumTypeOfTime;
            self.money = sourseKillModel.seckill_price;
        }
    }
}
- (void)setCourseGroupModel:(MDYCurriculumGroupModel *)courseGroupModel {
    _courseGroupModel = courseGroupModel;
    if (courseGroupModel) {
        [self.titleLabel setText:courseGroupModel.c_name];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:courseGroupModel.img]];
        if ([courseGroupModel.is_group integerValue] == 1) {
            self.noteLabel.hidden = NO;
            [self.noteLabel setText:[NSString stringWithFormat:@"%@人已学习",courseGroupModel.num]];
            self.type = MDYCurriculumTypeOfGroup;
            self.money = courseGroupModel.group_price;
        }
    }
}
- (void)setSearchCourseModel:(MDYSearchCurriculumModel *)searchCourseModel {
    _searchCourseModel = searchCourseModel;
    if (searchCourseModel) {
        [self.titleLabel setText:searchCourseModel.c_name];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:searchCourseModel.img]];
        if ([searchCourseModel.is_seckill integerValue] == 1) {
            self.type = MDYCurriculumTypeOfTime;
            self.money = searchCourseModel.seckill_price;
        } else if ([searchCourseModel.is_group integerValue] == 1) {
            self.type = MDYCurriculumTypeOfGroup;
            self.money = searchCourseModel.group_price;
        } else {
            self.type = 0;
            if ([searchCourseModel.is_pay integerValue] == 0) {
                self.money = @"免费";
            } else {
                self.money = searchCourseModel.price;
            }
        }
        self.noteLabel.hidden = NO;
        [self.noteLabel setText:[NSString stringWithFormat:@"%@人已学习",searchCourseModel.num]];
    }
}
- (void)setSearchGoodsModel:(MDYSearchGoodsModel *)searchGoodsModel {
    _searchGoodsModel = searchGoodsModel;
    if (searchGoodsModel) {
        [self.titleLabel setText:searchGoodsModel.goods_name];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:searchGoodsModel.goods_img]];
        if ([searchGoodsModel.is_seckill integerValue] == 1) {
            self.type = MDYCurriculumTypeOfTime;
            self.money = searchGoodsModel.seckill_price;
        } else if ([searchGoodsModel.is_group integerValue] == 1) {
            self.type = MDYCurriculumTypeOfGroup;
            self.money = searchGoodsModel.group_price;
        } else {
            self.type = 0;
            if ([searchGoodsModel.is_pay integerValue] == 0) {
                self.money = @"免费";
            } else {
                self.money = searchGoodsModel.price;
            }
        }
        self.noteLabel.hidden = NO;
        [self.noteLabel setText:[NSString stringWithFormat:@"%@人已购买",searchGoodsModel.num]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
