//
//  MDYOrderChangeGoodsWaybillRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderChangeGoodsWaybillRequest : MDYBaseRequest
CopyStringProperty order_num;
CopyStringProperty num_t;
CopyStringProperty name_t;
CopyStringProperty img_t;
@end

@interface MDYOrderChangeGoodsWaybillModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
