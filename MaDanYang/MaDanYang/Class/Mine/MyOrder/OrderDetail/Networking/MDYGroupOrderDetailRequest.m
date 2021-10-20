//
//  MDYGroupOrderDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/17.
//

#import "MDYGroupOrderDetailRequest.h"

@implementation MDYGroupOrderDetailRequest
- (NSString *)uri{
    return @"api/MyOrder/orderPintuanInfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYOrderInfoModel class];
}
@end

@implementation MDYGroupOrderDetailModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"order_goods" : [MDYGroupOrderInfoAddressModel class]};
}
@end

@implementation MDYGroupOrderInfoAddressModel

@end
@implementation MDYGroupOrderInfoGoodsModel

@end

