//
//  MDYCourseTypeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseTypeRequest : MDYBaseRequest

@end

@interface MDYCourseTypeModel : NSObject
CopyStringProperty uid;
CopyStringProperty name;
CopyStringProperty img;
@end

NS_ASSUME_NONNULL_END
