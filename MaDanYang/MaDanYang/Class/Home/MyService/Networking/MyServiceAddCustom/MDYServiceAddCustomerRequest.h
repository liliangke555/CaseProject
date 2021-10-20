//
//  MDYServiceAddCustomerRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYServiceAddCustomerRequest : MDYBaseRequest
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty txt;
@end

@interface MDYServiceAddCustomerModel : NSObject

@end

NS_ASSUME_NONNULL_END
