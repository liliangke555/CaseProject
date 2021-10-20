//
//  MDYIntegralGoodsListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYIntegralGoodsListRequest.h"

@implementation MDYIntegralGoodsListRequest
- (NSString *)uri{
    return @"api/IntegralGoods/goods";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIntegralGoodsListModel class];
}
@end

@implementation MDYIntegralGoodsListModel

@end
