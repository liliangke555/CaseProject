//
//  MDYCourseOrderEstablishReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseOrderEstablishReqeust : MDYBaseRequest
CopyStringProperty curriculum_id;
CopyStringProperty pay_type;
@end

@interface MDYCourseOrderEstablishModel : NSObject
CopyStringProperty data;
CopyStringProperty time;
@end

NS_ASSUME_NONNULL_END
