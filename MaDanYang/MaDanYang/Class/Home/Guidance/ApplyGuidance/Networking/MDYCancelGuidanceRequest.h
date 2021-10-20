//
//  MDYCancelGuidanceRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCancelGuidanceRequest : MDYBaseRequest
CopyStringProperty guidance_id;
@end

@interface MDYCancelGuidanceModel : NSObject
CopyStringProperty mdg;
@end

NS_ASSUME_NONNULL_END
