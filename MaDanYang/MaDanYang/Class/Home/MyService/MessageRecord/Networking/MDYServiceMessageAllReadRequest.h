//
//  MDYServiceMessageAllReadRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYServiceMessageAllReadRequest : MDYBaseRequest

@end

@interface MDYServiceMessageAllReadModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
