//
//  MDYPutQuestionTypeReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPutQuestionTypeReqeust : MDYBaseRequest

@end

@interface MDYPutQuestionTypeModel : NSObject
CopyStringProperty integral_type_id;
CopyStringProperty type_name;
@end

NS_ASSUME_NONNULL_END
