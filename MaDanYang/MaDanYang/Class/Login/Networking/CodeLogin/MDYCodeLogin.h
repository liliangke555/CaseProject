//
//  MDYCodeLogin.h
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCodeLogin : MDYBaseRequest
CopyStringProperty phone;
CopyStringProperty code;
@end

@interface MDYCodeLoginModel : NSObject
CopyStringProperty phone;
CopyStringProperty token;
@end

NS_ASSUME_NONNULL_END
