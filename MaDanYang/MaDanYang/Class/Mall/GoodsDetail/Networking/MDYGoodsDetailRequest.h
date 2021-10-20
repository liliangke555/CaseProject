//
//  MDYGoodsDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsDetailRequest : MDYBaseRequest
CopyStringProperty goods_id;
@end
@interface MDYGoodsDetailModel : NSObject
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty goods_info;
CopyStringProperty goods_img;
StrongProperty NSArray *goods_imgs;

CopyStringProperty seckill_price;
CopyStringProperty group_price;
CopyStringProperty price;
CopyStringProperty is_seckill;
CopyStringProperty is_group;

CopyStringProperty is_pay;
CopyStringProperty seckill_time;
CopyStringProperty a_id;

@end
NS_ASSUME_NONNULL_END
