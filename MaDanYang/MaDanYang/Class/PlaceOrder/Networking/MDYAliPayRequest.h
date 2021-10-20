//
//  MDYAliPayRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAliPayRequest : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYAliPayModel : NSObject
CopyStringProperty url;
CopyStringProperty data;

@end

NS_ASSUME_NONNULL_END
