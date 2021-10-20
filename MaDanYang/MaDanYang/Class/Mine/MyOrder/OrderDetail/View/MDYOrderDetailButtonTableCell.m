//
//  MDYOrderDetailButtonTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYOrderDetailButtonTableCell.h"

@interface MDYOrderDetailButtonTableCell ()
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *logisticsButton;

@end

@implementation MDYOrderDetailButtonTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
    [self.changeButton.layer setCornerRadius:4];
    [self.changeButton.layer setBorderWidth:1];
    [self.changeButton.layer setBorderColor:K_SeparatorColor.CGColor];
    [self.changeButton setClipsToBounds:YES];
    
    [self.logisticsButton.layer setCornerRadius:4];
    [self.logisticsButton.layer setBorderWidth:1];
    [self.logisticsButton.layer setBorderColor:K_SeparatorColor.CGColor];
    [self.logisticsButton setClipsToBounds:YES];
}
- (IBAction)changeButtonAction:(UIButton *)sender {
    if (self.didClickButton) {
        self.didClickButton(0);
    }
}
- (IBAction)logisticsButtonAction:(UIButton *)sender {
    if (self.didClickButton) {
        self.didClickButton(1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
