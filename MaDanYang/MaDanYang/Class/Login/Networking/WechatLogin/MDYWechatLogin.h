//
//  MDYWechatLogin.h
//  MaDanYang
//
//  Created by kckj on 2021/7/8.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYWechatLogin : MDYBaseRequest
CopyStringProperty openid;
CopyStringProperty nickname;
CopyStringProperty headimgurl;
@end

@interface MDYWechatLoginModel : NSObject
CopyStringProperty phone;
CopyStringProperty token;
@end

NS_ASSUME_NONNULL_END
