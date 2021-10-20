//
//  MDYSearchCollectionView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYSearchCollectionView : UICollectionReusableView
@property (nonatomic, copy) void(^didClickDelete)(void);
@end

NS_ASSUME_NONNULL_END
