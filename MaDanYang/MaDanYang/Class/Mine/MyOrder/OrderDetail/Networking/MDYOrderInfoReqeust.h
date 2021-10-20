//
//  MDYOrderInfoReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/30.
//

#import "MDYBaseRequest.h"
#import "MDYPlaceOrderRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderInfoReqeust : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYOrderInfoGoodsModel : NSObject
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty goods_img;
CopyStringProperty goods_price;
CopyStringProperty goods_num;
@end
@interface MDYOrderInfoAddressModel : NSObject
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty detailed_address;
@end
@interface MDYGroupOrderManModel : NSObject
CopyStringProperty buy_num;
CopyStringProperty create_time;
CopyStringProperty end_time;
CopyStringProperty goods_id;
CopyStringProperty group_id;

CopyStringProperty head_id;
CopyStringProperty head_member_img;
CopyStringProperty head_nickname;
CopyStringProperty is_promotion;
CopyStringProperty is_single_buy;

CopyStringProperty is_virtual_buy;
CopyStringProperty is_virtual_goods;
CopyStringProperty pintuan_count;
CopyStringProperty pintuan_id;
CopyStringProperty pintuan_num;
@end
@interface MDYOrderInfoModel : NSObject
StrongProperty NSArray <MDYOrderInfoGoodsModel *>*order_goods;
StrongProperty MDYOrderInfoAddressModel *address;
StrongProperty MDYPlaceOrderPayOfflineModel *pay_offline;
StrongProperty NSArray <MDYGroupOrderManModel *>*pintuanGroup;
CopyStringProperty pay_price;
CopyStringProperty integral;
CopyStringProperty creation_time;
CopyStringProperty pay_time;
CopyStringProperty state;
CopyStringProperty pay_type;
CopyStringProperty num;
@end

NS_ASSUME_NONNULL_END
