//
//  MDYUploadUserRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYUploadUserRequest : MDYBaseRequest
CopyStringProperty headimgurl;
CopyStringProperty nickname;
@end

@interface MDYUploadUserModel : NSObject

@end

NS_ASSUME_NONNULL_END
