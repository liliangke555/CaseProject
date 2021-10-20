//
//  MDYHeaderBannerView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "MDYHomeBannerRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYHeaderBannerView : UICollectionReusableView
@property (nonatomic, strong) NSArray *homeImageModels;
@property (nonatomic, copy) void(^didSelectedIndex)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
