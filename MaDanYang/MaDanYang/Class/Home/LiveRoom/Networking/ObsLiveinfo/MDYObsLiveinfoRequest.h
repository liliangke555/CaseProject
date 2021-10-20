//
//  MDYObsLiveinfoRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/11.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYObsLiveinfoRequest : MDYBaseRequest
CopyStringProperty obs_live_id;
CopyStringProperty invitation_code;
@end
@interface MDYObsLiveinfoModel : NSObject
CopyStringProperty obs_live_id;
CopyStringProperty live_title;
CopyStringProperty name;
CopyStringProperty head_portrait;
CopyStringProperty live_start_time;

CopyStringProperty live_start_ent;
CopyStringProperty live_notice;
CopyStringProperty live_state;
CopyStringProperty rtmpbofang;
CopyStringProperty udpbofang;

CopyStringProperty m3u8bofang;
CopyStringProperty fivbofang;
CopyStringProperty im_name;
CopyStringProperty introduction;
@end

NS_ASSUME_NONNULL_END
