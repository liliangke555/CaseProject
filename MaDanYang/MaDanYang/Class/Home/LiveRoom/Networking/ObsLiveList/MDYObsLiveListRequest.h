//
//  MDYObsLiveListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYObsLiveListRequest : MDYBaseRequest
AssignProperty NSInteger live_state;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYObsLiveListModel : NSObject
CopyStringProperty obs_live_id;
CopyStringProperty live_title;
CopyStringProperty name;
CopyStringProperty head_portrait;
CopyStringProperty live_start_time;

CopyStringProperty live_notice;
CopyStringProperty live_state;
CopyStringProperty lubo;
CopyStringProperty luboguoqi;
CopyStringProperty is_pay;

CopyStringProperty img;
CopyStringProperty num;
CopyStringProperty is_show;
StrongProperty NSArray *imgs;
@end

NS_ASSUME_NONNULL_END
