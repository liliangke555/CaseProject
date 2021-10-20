//
//  MDYTypeInquestionRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYTypeInquestionRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;

CopyStringProperty integral_type_id;
CopyStringProperty is_excellent;
@end

@interface MDYTypeInquestionModel : NSObject
CopyStringProperty put_questions_id;
CopyStringProperty put_title;
CopyStringProperty put_txt;
CopyStringProperty nickname;
CopyStringProperty headimgurl;

CopyStringProperty integral_type_name;
AssignProperty NSInteger integral_num;
@end

NS_ASSUME_NONNULL_END
