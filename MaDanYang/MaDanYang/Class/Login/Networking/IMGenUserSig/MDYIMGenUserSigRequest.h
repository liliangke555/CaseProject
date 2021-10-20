//
//  MDYIMGenUserSigRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/25.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIMGenUserSigRequest : MDYBaseRequest

@end

@interface MDYIMGenUserSigModel : NSObject
CopyStringProperty userSig;
CopyStringProperty uid;
@end

NS_ASSUME_NONNULL_END
