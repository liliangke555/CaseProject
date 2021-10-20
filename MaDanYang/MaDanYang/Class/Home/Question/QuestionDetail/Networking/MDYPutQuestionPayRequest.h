//
//  MDYPutQuestionPayRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPutQuestionPayRequest : MDYBaseRequest
CopyStringProperty put_questions_id;
CopyStringProperty integral_type_id;
@end
@interface MDYPutQuestionPayModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
