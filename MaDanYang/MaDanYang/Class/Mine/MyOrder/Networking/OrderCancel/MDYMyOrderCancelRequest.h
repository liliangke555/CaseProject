//
//  MDYMyOrderCancelRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/29.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyOrderCancelRequest : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYMyOrderCancelModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
