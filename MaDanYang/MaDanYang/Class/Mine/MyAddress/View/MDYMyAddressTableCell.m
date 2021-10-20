//
//  MDYMyAddressTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MDYMyAddressTableCell.h"

@interface MDYMyAddressTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation MDYMyAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteButtonAction:(UIButton *)sender {
    if (self.didClickDelete) {
        self.didClickDelete();
    }
}
- (IBAction)normalButtonAction:(id)sender {
    if (self.didClickSelected) {
        self.didClickSelected();
    }
}
- (IBAction)editButtonAction:(UIButton *)sender {
    if (self.didClickEdit) {
        self.didClickEdit();
    }
}
- (void)setNormal:(BOOL)normal {
    _normal = normal;
    [self.normalButton setSelected:normal];
}
- (void)setAddressModel:(MDYMyAddressListModel *)addressModel {
    _addressModel = addressModel;
    if (addressModel) {
        [self.nameLabel setText:addressModel.name];
        [self.phoneLabel setText:addressModel.phone];
        self.normal = [addressModel.is_default integerValue] == 1;
        [self.addressLabel setText:[NSString stringWithFormat:@"%@%@",addressModel.region,addressModel.detailed_address]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
