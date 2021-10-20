//
//  MDYGoodsAddCarRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsAddCarRequest : MDYBaseRequest
CopyStringProperty goods_id;
CopyStringProperty num;
CopyStringProperty is_default;
@end

@interface MDYGoodsAddCarModel : NSObject

@end

NS_ASSUME_NONNULL_END
