//
//  MDYIntegralOrderPayRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralOrderPayRequest : MDYBaseRequest
CopyStringProperty goods_id;
CopyStringProperty goods_num;
CopyStringProperty address_id;
@end

@interface MDYIntegralOrderPayModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
