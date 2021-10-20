//
//  MDYItemSubCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYItemSubCollectionCell.h"

@interface MDYItemSubCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MDYItemSubCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setTextColor:K_TextBlackColor];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}
- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    [self.imageView setImage:[UIImage imageNamed:imageString]];
}
@end
