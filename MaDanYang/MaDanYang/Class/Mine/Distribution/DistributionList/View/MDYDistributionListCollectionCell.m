//
//  MDYDistributionListCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/12.
//

#import "MDYDistributionListCollectionCell.h"

@implementation MDYDistributionListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:K_WhiteColor];
    [self.layer setCornerRadius:6];
    [self.layer setShadowColor:K_ShadowColor.CGColor];
    [self.layer setShadowRadius:10.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.layer setShadowOpacity:1.0f];
    [self setClipsToBounds:YES];
    self.layer.masksToBounds = NO;
    
    [self.detailButton.layer setCornerRadius:4];
    [self.detailButton setClipsToBounds:YES];
    self.detailButton.tag = 101;
    [self.distributionButton.layer setCornerRadius:4];
    [self.distributionButton setClipsToBounds:YES];
    [self.imageView.layer setCornerRadius:25];
    self.distributionButton.tag = 100;
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (self.didClickButtonAction) {
        self.didClickButtonAction(sender.tag - 100);
    }
}

@end
