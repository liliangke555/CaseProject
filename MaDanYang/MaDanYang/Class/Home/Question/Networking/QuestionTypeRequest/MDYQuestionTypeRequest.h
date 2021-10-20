//
//  MDYQuestionTypeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYQuestionTypeRequest : MDYBaseRequest

@end

@interface MDYQuestionTypeModel : NSObject
CopyStringProperty integral_type_id;
CopyStringProperty type_name;
@end

NS_ASSUME_NONNULL_END
