//
//  MDYGoodsCarSelectedOrCancelReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsCarSelectedOrCancelReqeust : MDYBaseRequest
CopyStringProperty goods_car_id;
@end

@interface MDYGoodsAllMoneyModel : NSObject
AssignProperty CGFloat choice_money;
@end

NS_ASSUME_NONNULL_END
