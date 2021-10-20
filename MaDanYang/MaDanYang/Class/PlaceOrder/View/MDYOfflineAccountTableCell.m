//
//  MDYOfflineAccountTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/26.
//

#import "MDYOfflineAccountTableCell.h"

@interface MDYOfflineAccountTableCell ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberlabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@end

@implementation MDYOfflineAccountTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self.topView setBackgroundColor:K_WhiteColor];
    [self.topView.layer setCornerRadius:6];
    [self.topView.layer setShadowColor:K_ShadowColor.CGColor];
    [self.topView.layer setShadowRadius:10.0f];
    [self.topView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.topView.layer setShadowOpacity:1.0f];
    [self.topView setClipsToBounds:YES];
    self.topView.layer.masksToBounds = NO;
}
- (void)setOfflineModel:(MDYPlaceOrderPayOfflineModel *)offlineModel {
    _offlineModel = offlineModel;
    if (offlineModel) {
        [self.nameLabel setText:[NSString stringWithFormat:@"账号：%@",offlineModel.account_name]];
        [self.numberlabel setText:[NSString stringWithFormat:@"户名：%@",offlineModel.account]];
        [self.bankNameLabel setText:[NSString stringWithFormat:@"开户行：%@",offlineModel.bank_of_deposit]];
    }
}
- (void)setCourseOfflineModel:(MDYCurriculumPayOfflineModel *)courseOfflineModel {
    _courseOfflineModel = courseOfflineModel;
    if (courseOfflineModel) {
        [self.nameLabel setText:[NSString stringWithFormat:@"账号：%@",courseOfflineModel.account_name]];
        [self.numberlabel setText:[NSString stringWithFormat:@"户名：%@",courseOfflineModel.account]];
        [self.bankNameLabel setText:[NSString stringWithFormat:@"开户行：%@",courseOfflineModel.bank_of_deposit]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
