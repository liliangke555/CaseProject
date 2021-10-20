//
//  MDYQRBangdingRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYQRBangdingRequest : MDYBaseRequest
CopyStringProperty u_id;
CopyStringProperty is_admin;
@end

@interface MDYQRBangdingModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
