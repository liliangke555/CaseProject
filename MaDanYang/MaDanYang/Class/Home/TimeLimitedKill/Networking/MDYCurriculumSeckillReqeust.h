//
//  MDYCurriculumSeckillReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/13.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCurriculumSeckillReqeust : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYCurriculumSeckillModel : NSObject
CopyStringProperty end_time;
CopyStringProperty uid;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;

CopyStringProperty is_pay;
CopyStringProperty seckill_price;
CopyStringProperty is_seckill;
CopyStringProperty seckill_id;
@end

NS_ASSUME_NONNULL_END
