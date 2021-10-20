//
//  MDYOrderOfflinePayController.h
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "CKBaseViewController.h"
#import "MDYOrderInfoReqeust.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderOfflinePayController : CKBaseViewController
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, strong) MDYOrderInfoModel *orderModel;
@end

NS_ASSUME_NONNULL_END
