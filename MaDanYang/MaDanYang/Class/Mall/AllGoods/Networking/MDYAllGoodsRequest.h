//
//  MDYAllGoodsRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAllGoodsRequest : MDYBaseRequest
AssignProperty NSInteger type_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYAllGoodsModel : NSObject
CopyStringProperty addon_group_id;
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
