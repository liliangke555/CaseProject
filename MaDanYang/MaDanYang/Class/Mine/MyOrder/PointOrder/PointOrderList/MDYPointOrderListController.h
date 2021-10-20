//
//  MDYPointOrderListController.h
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPointOrderListController : CKBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger orderState; //订单状态:全部：0,代付款：1，代发货：2，待收货：3
@end

NS_ASSUME_NONNULL_END
