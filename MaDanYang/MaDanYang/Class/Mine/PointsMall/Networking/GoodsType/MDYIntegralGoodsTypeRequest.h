//
//  MDYIntegralGoodsTypeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralGoodsTypeRequest : MDYBaseRequest

@end

@interface MDYIntegralGoodsTypeModel : NSObject
CopyStringProperty type_id;
CopyStringProperty type_name;
@end

NS_ASSUME_NONNULL_END
