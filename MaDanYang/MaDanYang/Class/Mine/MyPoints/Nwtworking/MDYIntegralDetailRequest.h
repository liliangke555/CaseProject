//
//  MDYIntegralDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralDetailRequest : MDYBaseRequest
CopyStringProperty integral_type_id;
AssignProperty NSInteger limit;
AssignProperty NSInteger page;
@end
@interface MDYIntegralDetailModel : NSObject
CopyStringProperty integral_type_id;
CopyStringProperty integral_type_name;
CopyStringProperty integral_num;
@end
NS_ASSUME_NONNULL_END
