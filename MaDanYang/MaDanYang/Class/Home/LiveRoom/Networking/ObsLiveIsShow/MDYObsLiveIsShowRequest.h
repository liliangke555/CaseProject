//
//  MDYObsLiveIsShowRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/11.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYObsLiveIsShowRequest : MDYBaseRequest
CopyStringProperty obs_live_id;
@end

@interface MDYObsLiveIsShowModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
