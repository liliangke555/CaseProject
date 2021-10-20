//
//  MDYImageCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYImageCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void)showDelete:(BOOL)showDelete deleteAction:(void (^_Nullable)(void))deleteAction;
@end

NS_ASSUME_NONNULL_END
