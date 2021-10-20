//
//  MDYSearchGoodsRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/31.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSearchGoodsRequest : MDYBaseRequest
CopyStringProperty key_word;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYSearchGoodsModel : NSObject
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
