//
//  MDYOrderAddressTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import "MDYOrderAddressTableCell.h"

@interface MDYOrderAddressTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *contentbgView;

@end

@implementation MDYOrderAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
    [self.contentbgView setBackgroundColor:K_WhiteColor];
    [self.contentbgView.layer setCornerRadius:6];
    [self.contentbgView.layer setShadowColor:K_ShadowColor.CGColor];
    [self.contentbgView.layer setShadowRadius:10.0f];
    [self.contentbgView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.contentbgView.layer setShadowOpacity:1.0f];
    [self.contentbgView setClipsToBounds:YES];
    self.contentbgView.layer.masksToBounds = NO;
    
    [self.normalView.layer setCornerRadius:4];
    [self.normalView setClipsToBounds:YES];
}
- (void)setAddressModel:(MDYPlaceOrderAddressModel *)addressModel {
    _addressModel = addressModel;
    if (addressModel) {
        [self.nameLabel setText:addressModel.name];
        [self.phoneLabel setText:addressModel.phone];
        [self.addressLabel setText:[NSString stringWithFormat:@"%@%@",addressModel.region?:@"",addressModel.detailed_address?:@""]];
        self.normalView.hidden = ![addressModel.is_default boolValue];
    }
}
- (void)setInfoAddressModel:(MDYOrderInfoAddressModel *)infoAddressModel {
    _infoAddressModel = infoAddressModel;
    if (infoAddressModel) {
        [self.nameLabel setText:infoAddressModel.name];
        [self.phoneLabel setText:infoAddressModel.phone];
        [self.addressLabel setText:[NSString stringWithFormat:@"%@%@",infoAddressModel.region?:@"",infoAddressModel.detailed_address?:@""]];
        self.normalView.hidden = YES;
    }
}
- (void)setIntegralAddressModel:(MDYIntergralOrderAddressModel *)integralAddressModel {
    _integralAddressModel = integralAddressModel;
    if (integralAddressModel) {
        [self.nameLabel setText:integralAddressModel.name];
        [self.phoneLabel setText:integralAddressModel.phone];
        [self.addressLabel setText:[NSString stringWithFormat:@"%@%@",integralAddressModel.region?:@"",integralAddressModel.detailed_address?:@""]];
        self.normalView.hidden = ![integralAddressModel.is_default boolValue];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
