//
//  MDYQuestionAnswerAreaRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYQuestionAnswerAreaRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYQuestionAnswerAreaModel : NSObject
CopyStringProperty put_questions_id;
CopyStringProperty put_title;
CopyStringProperty put_txt;
CopyStringProperty nickname;
CopyStringProperty headimgurl;

CopyStringProperty integral_type_name;
AssignProperty NSInteger integral_num;
@end

NS_ASSUME_NONNULL_END
