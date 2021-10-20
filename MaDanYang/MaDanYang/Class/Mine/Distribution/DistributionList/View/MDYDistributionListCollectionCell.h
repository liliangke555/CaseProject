//
//  MDYDistributionListCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYDistributionListCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIButton *distributionButton;
@property (nonatomic, copy) void(^didClickButtonAction)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
