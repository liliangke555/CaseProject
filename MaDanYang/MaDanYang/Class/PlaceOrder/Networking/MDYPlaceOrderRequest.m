//
//  MDYPlaceOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYPlaceOrderRequest.h"

@implementation MDYPlaceOrderRequest
- (NSString *)uri{
    return @"api/OrderCreate/ordercalCulationGoods";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPlaceOrderModel class];
}
@end

@implementation MDYPlaceOrderGoodsModel

@end

@implementation MDYPlaceOrderAddressModel

@end

@implementation MDYPlaceOrderPayOfflineModel

@end



@implementation MDYPlaceOrderModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"goods" : [MDYPlaceOrderGoodsModel class]};
}
@end
