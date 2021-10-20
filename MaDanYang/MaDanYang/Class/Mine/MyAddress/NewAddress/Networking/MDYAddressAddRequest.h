//
//  MDYAddressAddRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/17.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAddressAddRequest : MDYBaseRequest
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty detailed_address;
CopyStringProperty is_default;
@end
@interface MDYAddressAddModel : NSObject

@end
NS_ASSUME_NONNULL_END
