//
//  MDYOrderListController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderListController : CKBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger orderState; //订单状态:全部：0,代付款：1，代发货：2，待收货：3
@property (nonatomic, assign, getter=isGroupOrder) BOOL groupOrder;
@end

NS_ASSUME_NONNULL_END
