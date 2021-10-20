//
//  MDYCurriculumGroupRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/20.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCurriculumGroupRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end
@interface MDYCurriculumGroupModel : NSObject
CopyStringProperty end_time;
CopyStringProperty uid;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;

CopyStringProperty is_pay;
CopyStringProperty group_price;
CopyStringProperty is_group;
@end
NS_ASSUME_NONNULL_END
