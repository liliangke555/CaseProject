//
//  MDYMyAddressListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/17.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyAddressListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYMyAddressListModel : NSObject
CopyStringProperty address_id;
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty detailed_address;

CopyStringProperty is_default;
@end

NS_ASSUME_NONNULL_END
