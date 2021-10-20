//
//  MDYPutQuestionInfoRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPutQuestionInfoRequest : MDYBaseRequest
CopyStringProperty put_questions_id;
@end
@interface MDYPutQuestionInfoModel : NSObject
CopyStringProperty put_title;
CopyStringProperty put_txt;
CopyStringProperty imgs;
CopyStringProperty car_time;
CopyStringProperty admin_id;

CopyStringProperty nickname;
CopyStringProperty headimgurl;
CopyStringProperty admin_txt;
StrongProperty NSArray *admin_img;
CopyStringProperty admin_car_time;

CopyStringProperty integral_type_id;
CopyStringProperty put_questions_id;
AssignProperty NSInteger integral_num;
AssignProperty BOOL is_thumbs_up;

AssignProperty CGFloat contentHeight;
@end
NS_ASSUME_NONNULL_END
