//
//  MDYBuyGoodsView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MMPopupView.h"
#import "MDYGoodsDetailRequest.h"
#import "MDYCourseDetailRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYBuyGoodsView : MMPopupView
@property (nonatomic, assign) NSInteger goodsNum;
@property (nonatomic, copy) void(^didClickEnter)(NSInteger goodNum);
@property (nonatomic, strong) MDYGoodsDetailModel *goodsModel;
@property (nonatomic, strong) MDYCourseDetailModel *courseModel;
@end

NS_ASSUME_NONNULL_END
