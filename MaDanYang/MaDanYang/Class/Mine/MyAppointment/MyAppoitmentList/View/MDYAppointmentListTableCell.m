//
//  MDYAppointmentListTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/19.
//

#import "MDYAppointmentListTableCell.h"
@interface MDYAppointmentListTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;

@end

@implementation MDYAppointmentListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.flagView.layer setCornerRadius:4];
    [self.userImageView.layer setCornerRadius:16];
    [self.publicButton.layer setCornerRadius:4];
    [self.publicButton setClipsToBounds:YES];
}
- (IBAction)publicButtonAction:(UIButton *)sender {
    if (self.didClickPulic) {
        self.didClickPulic();
    }
}
- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 0) {
        [self.typeLabel setTextColor:KHexColor(0xF37575FF)];
//        [self.typeLabel setText:@"待审核"];
        [self.publicButton setHidden:YES];
    } else if (type == 1) {
        [self.typeLabel setTextColor:KHexColor(0x2D82E5FF)];
//        [self.typeLabel setText:@"待上门"];
        [self.publicButton setHidden:YES];
    } else if (type == 2) {
        [self.typeLabel setTextColor:K_TextLightGrayColor];
        
        [self.publicButton setHidden:NO];
    } else {
        [self.typeLabel setTextColor:K_TextLightGrayColor];
//        [self.typeLabel setText:@"已取消"];
        [self.publicButton setHidden:YES];
    }
}
- (void)setGuidanceModel:(MDYMyGuidanceListModel *)guidanceModel {
    _guidanceModel = guidanceModel;
    if (guidanceModel) {
        [self.titleLabel setText:[NSString stringWithFormat:@"%@的预约",guidanceModel.car_time]];
        [self.flagLabel setText:guidanceModel.type_name];
        if (guidanceModel.a_img.length > 0 || guidanceModel.a_name.length > 0) {
            self.userImageView.hidden= NO;
            [self.nameLabel setHidden:NO];
            [self.nameLabel setText:guidanceModel.a_name];
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:guidanceModel.a_img] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
        } else {
            self.userImageView.hidden= YES;
            [self.nameLabel setHidden:YES];
        }
        if ([guidanceModel.state isEqualToString:@"待审核"]) {
            self.type = 0;
        } else if ([guidanceModel.state isEqualToString:@"待上门"]) {
            self.type = 1;
        } else if ([guidanceModel.state isEqualToString:@"已取消"]) {
            self.type = 3;
        } else {
            self.type = 2;
        }
        [self.typeLabel setText:guidanceModel.state];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
