//
//  MDYAddMyCourseInfoRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/17.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAddMyCourseInfoRequest : MDYBaseRequest
CopyStringProperty c_id;
@end

@interface MDYAddMyCourseInfoModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
