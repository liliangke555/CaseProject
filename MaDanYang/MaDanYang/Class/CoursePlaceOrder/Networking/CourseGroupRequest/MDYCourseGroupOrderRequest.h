//
//  MDYCourseGroupOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseGroupOrderRequest : MDYBaseRequest
CopyStringProperty a_id;
CopyStringProperty address_id;
CopyStringProperty pay_type;
CopyStringProperty goods_num;
CopyStringProperty group_id;
@end

NS_ASSUME_NONNULL_END
