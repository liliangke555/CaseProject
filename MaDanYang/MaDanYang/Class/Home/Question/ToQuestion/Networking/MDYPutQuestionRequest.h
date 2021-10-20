//
//  MDYPutQuestionRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPutQuestionRequest : MDYBaseRequest
CopyStringProperty put_title;
CopyStringProperty put_txt;
CopyStringProperty imgs;
CopyStringProperty integral_type_id;
@end

@interface MDYPutQuestionModel : NSObject

@end

NS_ASSUME_NONNULL_END
