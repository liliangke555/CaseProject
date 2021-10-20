//
//  MDYMyCourseInfoRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyCourseInfoRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
CopyStringProperty curriculum_my_id;
@end

@interface MDYMyCourseInfoModel : NSObject
CopyStringProperty curriculum_catalog_my_id;
CopyStringProperty curriculum_name;
CopyStringProperty video_src;
CopyStringProperty is_show;
@end

NS_ASSUME_NONNULL_END
