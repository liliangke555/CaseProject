//
//  MDYSumitOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSumitOrderRequest : MDYBaseRequest
CopyStringProperty goods_id;
CopyStringProperty goods_num;
CopyStringProperty address_id;
CopyStringProperty pay_type;
@end

@interface MDYSumitOrderModel : NSObject
CopyStringProperty data;
CopyStringProperty time;
@end

NS_ASSUME_NONNULL_END
