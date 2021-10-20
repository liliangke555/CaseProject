//
//  MDYGuidenceCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "MDYGuidenceCollectionCell.h"

@interface MDYGuidenceCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MDYGuidenceCollectionCell

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
    
    [self.nameLabel setTextColor:K_TextGrayColor];
    [self.timeLabel setTextColor:K_TextGrayColor];
    [self.titleLabel setTextColor:K_TextBlackColor];
    
    [self.headerImageView.layer setCornerRadius:16];
    [self.headerImageView setClipsToBounds:YES];
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setGuidaceModel:(MDYGuidanceListModel *)guidaceModel {
    _guidaceModel = guidaceModel;
    if (guidaceModel) {
        [self.titleLabel setText:guidaceModel.title];
        self.imageUrl = guidaceModel.img;
        [self.timeLabel setText:guidaceModel.cartime];
        [self.nameLabel setText:guidaceModel.usename];
    }
}
@end
