//
//  MDYLiveRoomTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYLiveRoomTableCell.h"

@interface MDYLiveRoomTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;

@end

@implementation MDYLiveRoomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleLabel setTextColor:K_TextBlackColor];
    [self.timeView.layer setCornerRadius:2];
    [self.timeLabel setTextColor:K_MainColor];
    [self.bigImageView.layer setCornerRadius:6];
    [self.headerImageView.layer setCornerRadius:16];
    [self.flagView.layer setCornerRadius:4];
    [self.flagView setClipsToBounds:YES];
    
    [self.imageViewOne.layer setCornerRadius:4];
    [self.imageViewTwo.layer setCornerRadius:4];
    
    [self.button.layer setCornerRadius:4];
    [self.button.layer setBorderWidth:1];
    [self.button setClipsToBounds:YES];
}
- (IBAction)buttonAction:(UIButton *)sender {
    if ([self.listModel.live_state integerValue] == 0) {
        if (self.didShowAction) {
            self.didShowAction();
        }
    }
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setType:(MDYLiveRoomType)type {
    _type =type;
    
    [self.timeView setHidden:NO];
    [self.timeLabel setHidden:NO];
    
    [self.imageViewOne setHidden:YES];
    [self.imageViewTwo setHidden:YES];
    
    if (type == 0) {
        
        [self.flagImageView setImage:[UIImage imageNamed:@"live_room_living"]];
        [self.flagLabel setText:[NSString stringWithFormat:@"%@人观看",self.listModel.num]];
        [self.timeView setHidden:YES];
        [self.timeLabel setHidden:YES];
        [self.button setTitle:@"  看直播" forState:UIControlStateNormal];
        [self.button setTitleColor:K_TextMoneyColor forState:UIControlStateNormal];
        [self.button.layer setBorderColor:K_TextMoneyColor.CGColor];
        [self.button setBackgroundColor:K_WhiteColor];
        [self.button setImage:[UIImage imageNamed:@"live_room_lock"] forState:UIControlStateNormal];
    } else if (type == 1) {
        [self.flagImageView setImage:[UIImage imageNamed:@"live_room_living"]];
        [self.flagLabel setText:[NSString stringWithFormat:@"%@人观看",self.listModel.num]];
        [self.timeView setHidden:YES];
        [self.timeLabel setHidden:YES];
        [self.button setTitle:@"看直播" forState:UIControlStateNormal];
        [self.button setBackgroundColor:K_WhiteColor];
        [self.button setTitleColor:K_TextMoneyColor forState:UIControlStateNormal];
        [self.button.layer setBorderColor:K_TextMoneyColor.CGColor];
        [self.button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    } else if (type == 2) {
        [self.flagImageView setImage:[UIImage imageNamed:@"live_room_notice"]];
        [self.flagLabel setText:@"预告"];
        [self.timeLabel setText:[NSString stringWithFormat:@"直播时间：%@",self.listModel.live_start_time]];
        [self.button setTitle:@"已订阅" forState:UIControlStateNormal];
        [self.button setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [self.button.layer setBorderColor:K_MainColor.CGColor];
        [self.button setBackgroundColor:K_MainColor];
        [self.button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    } else if (type == 3) {
        [self.flagImageView setImage:[UIImage imageNamed:@"live_room_notice"]];
        [self.flagLabel setText:@"预告"];
        [self.timeLabel setText:[NSString stringWithFormat:@"直播时间：%@",self.listModel.live_start_time]];
        [self.button setTitle:@"开播提醒" forState:UIControlStateNormal];
        [self.button setTitleColor:K_MainColor forState:UIControlStateNormal];
        [self.button.layer setBorderColor:K_MainColor.CGColor];
        [self.button setBackgroundColor:K_WhiteColor];
        [self.button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    } else {
        [self.flagImageView setImage:[UIImage imageNamed:@"live_room_over"]];
        [self.flagLabel setText:@"直播回放"];
        [self.timeLabel setText:@"时长：2小时"];
        [self.button setHidden:YES];
        if (self.listModel.imgs.count > 0) {
            if (self.listModel.imgs.count > 1) {
                [self.imageViewOne setHidden:NO];
                [self.imageViewTwo setHidden:NO];
                [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:self.listModel.imgs[0]]];
                [self.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:self.listModel.imgs[1]]];
            } else {
                [self.imageViewOne setHidden:YES];
                [self.imageViewTwo setHidden:NO];
                [self.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:self.listModel.imgs[0]]];
            }
        }
    }
}
- (void)setListModel:(MDYObsLiveListModel *)listModel {
    _listModel = listModel;
    if (listModel) {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:listModel.img]];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:listModel.head_portrait] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
        [self.titleLabel setText:listModel.live_title];
        [self.nameLabel setText:listModel.name];
        if ([listModel.live_state integerValue] == 0) {
            if ([listModel.is_show integerValue] == 1) {
                self.type = 2;
            } else {
                self.type = 3;
            }
        } else if ([listModel.live_state integerValue] == 1) {
            if ([listModel.is_pay integerValue] == 1) {
                self.type = 0;
            } else {
                self.type = 1;
            }
        } else {
            self.type = 4;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
