//
//  MDYIntergralOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/7.
//

#import "MDYIntergralOrderRequest.h"

@implementation MDYIntergralOrderRequest
- (NSString *)uri{
    return @"api/IntegralOrder/integral_order";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYIntergralOrderModel class];
}
@end

@implementation MDYIntergralOrderGoodsModel

@end

@implementation MDYIntergralOrderAddressModel

@end


@implementation MDYIntergralOrderModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"goods" : [MDYIntergralOrderGoodsModel class]};
}
@end
