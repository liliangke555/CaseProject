//
//  MDYShoppingCarOrderRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYShoppingCarOrderRequest : MDYBaseRequest
CopyStringProperty address_id;
CopyStringProperty pay_type;
@end

//@interface MDYShoppingOrderGoodsModel : NSObject
//CopyStringProperty goods_id;
//CopyStringProperty goods_name;
//CopyStringProperty goods_img;
//CopyStringProperty price;
//CopyStringProperty goods_num;
//CopyStringProperty integral;
//@end
//
//@interface MDYShoppingOrderAddressModel : NSObject
//CopyStringProperty address_id;
//CopyStringProperty name;
//CopyStringProperty phone;
//CopyStringProperty region;
//CopyStringProperty detailed_address;
//CopyStringProperty is_default;
//@end
//
//@interface MDYShoppingOrderPayOfflineModel : NSObject
//CopyStringProperty bank_of_deposit;
//CopyStringProperty account_name;
//CopyStringProperty account;
//@end
//
//@interface MDYShoppingOrderModel : NSObject
//StrongProperty NSArray <MDYShoppingOrderGoodsModel *>*goods;
//StrongProperty MDYShoppingOrderAddressModel *address;
//StrongProperty MDYShoppingOrderPayOfflineModel *pay_offline;
//CopyStringProperty pay_price;
//@end
NS_ASSUME_NONNULL_END
