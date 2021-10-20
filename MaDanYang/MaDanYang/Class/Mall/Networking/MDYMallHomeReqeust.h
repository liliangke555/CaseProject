//
//  MDYMallHomeReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMallHomeReqeust : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end


@interface MDYMallHomeModel : NSObject
// 商品ID
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty num;
CopyStringProperty price;
CopyStringProperty group_price;

CopyStringProperty seckill_price;
CopyStringProperty is_seckill;
CopyStringProperty is_group;
CopyStringProperty is_pay;
CopyStringProperty goods_img;
@end

NS_ASSUME_NONNULL_END
