//
//  MDYOrderChangeGoodsRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderChangeGoodsRequest : MDYBaseRequest
CopyStringProperty order_num;
CopyStringProperty txt;
CopyStringProperty imgs;
@end

@interface MDYOrderChangeGoodsModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
