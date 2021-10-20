//
//  MDYPayOfflineController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import "CKBaseViewController.h"
#import "MDYPlaceOrderRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYPayOfflineController : CKBaseViewController
@property (nonatomic, strong) MDYPlaceOrderModel *orderModel;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *orderTime;
@end

NS_ASSUME_NONNULL_END
