//
//  MDYSearchHistoryCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import "MDYSearchHistoryCollectionCell.h"

@interface MDYSearchHistoryCollectionCell ()

@end

@implementation MDYSearchHistoryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setTextColor:K_TextBlackColor];
}
#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}
@end
