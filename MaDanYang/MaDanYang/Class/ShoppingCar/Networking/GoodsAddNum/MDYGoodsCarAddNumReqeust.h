//
//  MDYGoodsCarAddNumReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsCarAddNumReqeust : MDYBaseRequest
CopyStringProperty goods_car_id;
@end

@interface MDYGoodsCarAddNumModel : NSObject
AssignProperty CGFloat choice_money;
CopyStringProperty num;
@end

NS_ASSUME_NONNULL_END
