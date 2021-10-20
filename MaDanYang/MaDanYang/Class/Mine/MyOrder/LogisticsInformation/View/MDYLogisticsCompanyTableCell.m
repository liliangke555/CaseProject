//
//  MDYLogisticsCompanyTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYLogisticsCompanyTableCell.h"

@interface MDYLogisticsCompanyTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLABEL;

@end

@implementation MDYLogisticsCompanyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImageView.layer setCornerRadius:20];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setInfoModel:(MDYOrderSynquerysModel *)infoModel {
    _infoModel = infoModel;
    if (infoModel) {
        [self.nameLabel setText:infoModel.com];
        [self.orderLABEL setText:[NSString stringWithFormat:@"运单信息：%@",infoModel.condition]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
