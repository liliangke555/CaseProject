//
//  MDYIntergralOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/7.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntergralOrderRequest : MDYBaseRequest
CopyStringProperty goods_id;
CopyStringProperty goods_num;
CopyStringProperty address_id;
@end

@interface MDYIntergralOrderGoodsModel : NSObject
CopyStringProperty goods_car_id;
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty goods_img;
CopyStringProperty goods_num;
CopyStringProperty price;
@end

@interface MDYIntergralOrderAddressModel : NSObject
CopyStringProperty address_id;
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty detailed_address;
CopyStringProperty is_default;
@end

@interface MDYIntergralOrderPayOfflineModel : NSObject
CopyStringProperty bank_of_deposit;
CopyStringProperty account_name;
CopyStringProperty account;
@end

@interface MDYIntergralOrderModel : NSObject
StrongProperty NSArray <MDYIntergralOrderGoodsModel *>*goods;
StrongProperty MDYIntergralOrderAddressModel *address;
CopyStringProperty pay_offline;
CopyStringProperty pay_price;
@end

NS_ASSUME_NONNULL_END
