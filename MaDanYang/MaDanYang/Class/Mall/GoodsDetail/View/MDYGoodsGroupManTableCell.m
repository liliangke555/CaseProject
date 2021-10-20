//
//  MDYGoodsGroupManTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MDYGoodsGroupManTableCell.h"

@interface MDYGoodsGroupManTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *oneHeadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *toButton;

@end

@implementation MDYGoodsGroupManTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.oneHeadImageView.layer setCornerRadius:20];
    [self.twoHeadImageView.layer setCornerRadius:20];
    
    [self.toButton.layer setCornerRadius:4];
    [self.toButton setClipsToBounds:YES];
}
- (IBAction)toButtonAction:(UIButton *)sender {
    if (self.didJoinGroup) {
        self.didJoinGroup(self.model.data[0]);
    }
}
- (void)setModel:(MDYMyGoodsGroupListModel *)model {
    _model = model;
    if (model) {
        NSMutableString *onename = [NSMutableString stringWithString:@""];
        if (model.data.count > 0) {
            MDYMyGoodsGroupModel *oneModel = model.data[0];
            [self.oneHeadImageView sd_setImageWithURL:[NSURL URLWithString:oneModel.head_member_img] placeholderImage:[UIImage imageNamed:@"group_empty_icon"]];
            [onename appendString:oneModel.head_nickname];
        }
        if (model.data.count > 1) {
            MDYMyGoodsGroupModel *oneModel = model.data[1];
            [self.twoHeadImageView sd_setImageWithURL:[NSURL URLWithString:oneModel.head_member_img] placeholderImage:[UIImage imageNamed:@"group_empty_icon"]];
            [onename appendString:@"、"];
            [onename appendString:oneModel.head_nickname];
        }
        [self.nameLabel setText:onename];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
