//
//  MDYPlatformCerCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYPlatformCerCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^didClickChangeType)(void);
@property (nonatomic, copy) void(^didClickSelectedImage)(void);
@property (nonatomic, copy) void(^didEndEditName)(NSString *string);
@property (nonatomic, copy) void(^didEndEditAddress)(NSString *string);
@property (nonatomic, strong) MDYUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
