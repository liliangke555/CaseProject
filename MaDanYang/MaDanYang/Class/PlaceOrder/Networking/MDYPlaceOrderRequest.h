//
//  MDYPlaceOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPlaceOrderRequest : MDYBaseRequest
CopyStringProperty goods_id;
CopyStringProperty goods_num;
CopyStringProperty address_id;
CopyStringProperty pay_type;
@end

@interface MDYPlaceOrderGoodsModel : NSObject
CopyStringProperty goods_car_id;
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty goods_img;
CopyStringProperty price;
CopyStringProperty goods_num;
CopyStringProperty integral;
@end

@interface MDYPlaceOrderAddressModel : NSObject
CopyStringProperty address_id;
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty detailed_address;
CopyStringProperty is_default;
@end

@interface MDYPlaceOrderPayOfflineModel : NSObject
CopyStringProperty bank_of_deposit;
CopyStringProperty account_name;
CopyStringProperty account;
@end

@interface MDYPlaceOrderModel : NSObject
StrongProperty NSArray <MDYPlaceOrderGoodsModel *>*goods;
StrongProperty MDYPlaceOrderAddressModel *address;
StrongProperty MDYPlaceOrderPayOfflineModel *pay_offline;
CopyStringProperty pay_price;
@end



NS_ASSUME_NONNULL_END
