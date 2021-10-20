//
//  MDYFreeCourseRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYFreeCourseRequest : MDYBaseRequest
CopyStringProperty type_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYFreeCourseModel : NSObject
CopyStringProperty uid;
CopyStringProperty type_id;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;
CopyStringProperty is_pay;
AssignProperty NSInteger is_seckill;
@end

NS_ASSUME_NONNULL_END
