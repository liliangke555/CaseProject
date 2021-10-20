//
//  MDYPrimaryDistributionRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPrimaryDistributionRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
CopyStringProperty key;
@end

@interface MDYPrimaryDistributionModel : NSObject
CopyStringProperty u_id;
CopyStringProperty headimgurl;
CopyStringProperty nickname;
CopyStringProperty frequency;
CopyStringProperty refer_unm;
@end

NS_ASSUME_NONNULL_END
