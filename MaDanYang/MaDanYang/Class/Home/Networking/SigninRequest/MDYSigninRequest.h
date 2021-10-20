//
//  MDYSigninRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSigninRequest : MDYBaseRequest

@end

@interface MDYSigninModel : NSObject
CopyStringProperty data;
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
