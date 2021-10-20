//
//  MDYPayOfflineReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPayOfflineReqeust : MDYBaseRequest
CopyStringProperty order_num;
CopyStringProperty offline_url;
@end

@interface MDYPayOfflineModel : NSObject

@end

NS_ASSUME_NONNULL_END
