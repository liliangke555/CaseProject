//
//  MDYSumitCarOrderReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSumitCarOrderReqeust : MDYBaseRequest
CopyStringProperty address_id;
CopyStringProperty pay_type;
@end

@interface MDYSumitCarOrderModel : NSObject
CopyStringProperty data;
CopyStringProperty time;
@end

NS_ASSUME_NONNULL_END
