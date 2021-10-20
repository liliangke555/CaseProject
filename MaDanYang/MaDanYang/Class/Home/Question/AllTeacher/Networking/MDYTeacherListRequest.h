//
//  MDYTeacherListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/31.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYTeacherListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
AssignProperty NSInteger is_excellent;
@end

@interface MDYTeacherListModel : NSObject
CopyStringProperty admin_id;
CopyStringProperty head_portrait;
CopyStringProperty name;
CopyStringProperty num;
AssignProperty NSInteger integral_num;
CopyStringProperty is_excellent;
@end

NS_ASSUME_NONNULL_END
