//
//  MDYMyCourseStudyRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyCourseStudyRequest : MDYBaseRequest
CopyStringProperty curriculum_catalog_my_id;
@end

@interface MDYMyCourseStudyModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
