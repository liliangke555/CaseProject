//
//  MDYExclusiveTypeCourseRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/9/16.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYExclusiveTypeCourseRequest : MDYBaseRequest
CopyStringProperty type_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

NS_ASSUME_NONNULL_END
