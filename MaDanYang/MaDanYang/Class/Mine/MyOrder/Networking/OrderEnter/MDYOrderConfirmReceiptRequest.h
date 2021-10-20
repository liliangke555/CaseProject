//
//  MDYOrderConfirmReceiptRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderConfirmReceiptRequest : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYOrderConfirmReceiptModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
