//
//  MDYPhoneCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYPhoneCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBUtton;
@property (nonatomic, copy) void(^didClickCallPhone)(void);
@end

NS_ASSUME_NONNULL_END
