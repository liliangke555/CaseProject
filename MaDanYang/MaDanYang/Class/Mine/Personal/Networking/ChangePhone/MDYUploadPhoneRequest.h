//
//  MDYUploadPhoneRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYUploadPhoneRequest : MDYBaseRequest
CopyStringProperty phone;
CopyStringProperty code;
@end

@interface MDYUploadPhoneModel : NSObject

@end

NS_ASSUME_NONNULL_END
