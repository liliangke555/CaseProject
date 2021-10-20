//
//  MDYDistributionCoinCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYDistributionCoinCollectionCell.h"

@implementation MDYDistributionCoinCollectionCell

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
}

@end
