//
//  MDYOrderEstablishRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderEstablishRequest : MDYBaseRequest
CopyStringProperty curriculum_id;
@end

@interface MDYOrderEstablishModel : NSObject
CopyStringProperty order_num;
@end

NS_ASSUME_NONNULL_END
