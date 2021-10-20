//
//  MDYGoodsBannerView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsBannerView : UIView
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, copy) void(^didClickImage)(SDCycleScrollView *view,NSInteger index);
@end

NS_ASSUME_NONNULL_END
