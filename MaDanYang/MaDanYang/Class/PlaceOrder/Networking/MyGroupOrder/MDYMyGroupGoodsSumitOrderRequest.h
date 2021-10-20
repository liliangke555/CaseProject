//
//  MDYMyGroupGoodsSumitOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyGroupGoodsSumitOrderRequest : MDYBaseRequest
CopyStringProperty a_id;
CopyStringProperty address_id;
CopyStringProperty pay_type;
CopyStringProperty goods_num;
CopyStringProperty group_id;
@end

@interface MDYMyGroupGoodsSumitOrderModel : NSObject
CopyStringProperty data;
CopyStringProperty time;
@end

NS_ASSUME_NONNULL_END
