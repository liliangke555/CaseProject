//
//  MDYIntegralGoodsTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYIntegralGoodsTypeRequest.h"

@implementation MDYIntegralGoodsTypeRequest
- (NSString *)uri{
    return @"api/goods/goods_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIntegralGoodsTypeModel class];
}
@end

@implementation MDYIntegralGoodsTypeModel

@end
