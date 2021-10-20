//
//  MDYHomeExclusiveCourseRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYHomeExclusiveCourseRequest : MDYBaseRequest

@end

@interface MDYHomeExclusiveCourseModel : NSObject
CopyStringProperty uid;
CopyStringProperty type_id;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;

CopyStringProperty is_pay;
CopyStringProperty price;
CopyStringProperty seckill_price;
CopyStringProperty is_seckill;
CopyStringProperty group_price;

CopyStringProperty is_group;
@end

NS_ASSUME_NONNULL_END
