//
//  MDYVerificationRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYVerificationRequest : MDYBaseRequest
CopyStringProperty enterprise_name;
CopyStringProperty enterprise_add;
CopyStringProperty enterprise_type;
CopyStringProperty enterprise_img;
@end

@interface MDYVerificationModel : NSObject

@end

NS_ASSUME_NONNULL_END
