//
//  MDYMyIntegralAllRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyIntegralAllRequest : MDYBaseRequest

@end

@interface MDYMyIntegralAllModel : NSObject
CopyStringProperty integral_type_id;
CopyStringProperty integral_type_name;
CopyStringProperty sum_integral_num;
@end

NS_ASSUME_NONNULL_END
