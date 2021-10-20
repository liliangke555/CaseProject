//
//  MDYLikeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYLikeRequest : MDYBaseRequest
CopyStringProperty type;
CopyStringProperty jl_id;

@end

@interface MDYLikeModel : NSObject
CopyStringProperty info;
@end

NS_ASSUME_NONNULL_END
