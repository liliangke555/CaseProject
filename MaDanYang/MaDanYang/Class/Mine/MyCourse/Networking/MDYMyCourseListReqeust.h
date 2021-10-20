//
//  MDYMyCourseListReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyCourseListReqeust : MDYBaseRequest
AssignProperty NSInteger limit;
AssignProperty NSInteger page;
@end

@interface MDYMyCourseListModel : NSObject
CopyStringProperty curriculum_my_id;
CopyStringProperty curriculum_img;
CopyStringProperty curriculum_name;
StrongProperty NSArray *curriculum_type;
CopyStringProperty progress_bar;
@end

NS_ASSUME_NONNULL_END
