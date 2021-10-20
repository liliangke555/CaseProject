//
//  MDYPointsExchangeView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MMPopupView.h"
#import "MDYIntegralGoodsListRequest.h"
#import "MDYIntegralCourseListReqeust.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPointsExchangeView : MMPopupView
@property (nonatomic, strong) MDYIntegralGoodsListModel *goodsModel;
@property (nonatomic, strong) MDYIntegralCourseListModel *courseModel;
@property (nonatomic, copy) void(^didClickEnter)(void);
@end

NS_ASSUME_NONNULL_END
