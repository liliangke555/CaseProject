//
//  MDYGoodsCarDeleteRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/9/14.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsCarDeleteRequest : MDYBaseRequest
CopyStringProperty goods_car_id;
@end

@interface MDYGoodsCarDeleteModel : NSObject
AssignProperty CGFloat choice_money;
@end

NS_ASSUME_NONNULL_END
