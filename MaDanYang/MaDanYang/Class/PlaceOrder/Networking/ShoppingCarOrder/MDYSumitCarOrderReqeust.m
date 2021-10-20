//
//  MDYSumitCarOrderReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYSumitCarOrderReqeust.h"

@implementation MDYSumitCarOrderReqeust
- (NSString *)uri{
    return @"api/OrderCreate/ordercalCar";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYSumitCarOrderModel class];
}
@end

@implementation MDYSumitCarOrderModel

@end
