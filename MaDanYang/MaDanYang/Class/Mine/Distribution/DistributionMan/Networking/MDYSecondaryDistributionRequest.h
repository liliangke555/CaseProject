//
//  MDYSecondaryDistributionRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSecondaryDistributionRequest : MDYBaseRequest
CopyStringProperty u_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
CopyStringProperty key;
@end

@interface MDYSecondaryDistributionModel : NSObject
CopyStringProperty u_id;
CopyStringProperty headimgurl;
CopyStringProperty nickname;
CopyStringProperty frequency;
CopyStringProperty refer_unm;
@end

NS_ASSUME_NONNULL_END
