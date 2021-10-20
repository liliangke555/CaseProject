//
//  MDYGroupOrderDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/9/17.
//

#import "MDYBaseRequest.h"
#import "MDYOrderInfoReqeust.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYGroupOrderDetailRequest : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYGroupOrderInfoAddressModel : NSObject
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty goods_img;
CopyStringProperty goods_price;
CopyStringProperty goods_num;
@end
@interface MDYGroupOrderInfoGoodsModel : NSObject
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty detailed_address;
@end
@interface MDYGroupOrderDetailModel : NSObject
StrongProperty NSArray <MDYGroupOrderInfoGoodsModel *>*order_goods;
StrongProperty MDYGroupOrderInfoAddressModel *address;
StrongProperty MDYPlaceOrderPayOfflineModel *pay_offline;
CopyStringProperty pay_price;
CopyStringProperty integral;
CopyStringProperty creation_time;
CopyStringProperty pay_time;
CopyStringProperty state;
CopyStringProperty pay_type;
@end

NS_ASSUME_NONNULL_END
