//
//  MDYAllCourseRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAllCourseRequest : MDYBaseRequest
CopyStringProperty type_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYAllCourseModel : NSObject
CopyStringProperty uid;
CopyStringProperty type_id;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;
CopyStringProperty is_pay;
CopyStringProperty is_seckill;
CopyStringProperty is_group;
CopyStringProperty seckill_price;
CopyStringProperty group_price;
CopyStringProperty price;
@end

NS_ASSUME_NONNULL_END
