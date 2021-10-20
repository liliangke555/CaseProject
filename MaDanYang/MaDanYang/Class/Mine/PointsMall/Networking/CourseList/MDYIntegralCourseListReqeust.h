//
//  MDYIntegralCourseListReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralCourseListReqeust : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
CopyStringProperty type_id;
@end

@interface MDYIntegralCourseListModel : NSObject
CopyStringProperty uid;
CopyStringProperty type_id;
CopyStringProperty img;
CopyStringProperty c_name;
CopyStringProperty num;
CopyStringProperty integral;
@end

NS_ASSUME_NONNULL_END
