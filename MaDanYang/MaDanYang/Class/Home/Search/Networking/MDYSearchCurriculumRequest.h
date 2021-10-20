//
//  MDYSearchCurriculumRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/30.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSearchCurriculumRequest : MDYBaseRequest
CopyStringProperty key_word;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYSearchCurriculumModel : NSObject
CopyStringProperty uid;
CopyStringProperty type_id;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;

CopyStringProperty is_pay;
CopyStringProperty is_seckill;
CopyStringProperty is_group;
CopyStringProperty group_price;
CopyStringProperty seckill_price;

CopyStringProperty price;
@end

NS_ASSUME_NONNULL_END
