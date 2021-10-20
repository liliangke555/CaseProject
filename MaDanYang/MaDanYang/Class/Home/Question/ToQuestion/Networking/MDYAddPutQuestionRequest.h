//
//  MDYAddPutQuestionRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAddPutQuestionRequest : MDYBaseRequest
CopyStringProperty admin_id;
CopyStringProperty put_title;
CopyStringProperty put_txt;
CopyStringProperty imgs;
CopyStringProperty integral_type_id;
@end

@interface MDYAddPutQuestionModel : NSObject

@end

NS_ASSUME_NONNULL_END
