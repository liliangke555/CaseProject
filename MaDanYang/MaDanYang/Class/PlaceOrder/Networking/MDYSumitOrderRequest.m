//
//  MDYSumitOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYSumitOrderRequest.h"

@implementation MDYSumitOrderRequest
- (NSString *)uri{
    return @"api/OrderCreate/ordercalGoods";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYSumitOrderModel class];
}
@end

@implementation MDYSumitOrderModel

@end
