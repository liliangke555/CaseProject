//
//  MDYCourseDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseDetailRequest : MDYBaseRequest
CopyStringProperty c_id;
@end

@interface MDYCourseDetailModel : NSObject

CopyStringProperty uid;
CopyStringProperty type_id;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty price;

CopyStringProperty src_trial;
CopyStringProperty t_img;
CopyStringProperty t_name;
StrongProperty NSArray *biaoqian;
CopyStringProperty info;

CopyStringProperty is_pay;
CopyStringProperty is_group;
CopyStringProperty is_seckill;
CopyStringProperty group_price;
CopyStringProperty seckill_price;

CopyStringProperty num;
CopyStringProperty count;
CopyStringProperty a_id;
CopyStringProperty end_time;
@end

NS_ASSUME_NONNULL_END
