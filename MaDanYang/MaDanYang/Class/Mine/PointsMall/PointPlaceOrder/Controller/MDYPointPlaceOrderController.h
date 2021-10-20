//
//  MDYPointPlaceOrderController.h
//  MaDanYang
//
//  Created by kckj on 2021/8/7.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPointPlaceOrderController : CKBaseViewController
@property (nonatomic, copy) NSString *goodId;
@property (nonatomic, assign, getter=isGoods) BOOL goods;
@end

NS_ASSUME_NONNULL_END
