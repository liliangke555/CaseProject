//
//  MDYShoppingCarOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYShoppingCarOrderRequest.h"
#import "MDYPlaceOrderRequest.h"
@implementation MDYShoppingCarOrderRequest
- (NSString *)uri{
    return @"api/OrderCreate/ordercalCulationCar";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPlaceOrderModel class];
}
@end

//@implementation MDYShoppingOrderGoodsModel
//
//@end
//
//@implementation MDYShoppingOrderAddressModel
//
//@end
//
//@implementation MDYShoppingOrderPayOfflineModel
//
//@end
