//
//  MDYServiceMessageReadRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYServiceMessageReadRequest : MDYBaseRequest
CopyStringProperty cid;
@end

@interface MDYServiceMessageReadModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
