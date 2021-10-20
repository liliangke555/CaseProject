//
//  MDYAllGoodsRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYAllGoodsRequest.h"

@implementation MDYAllGoodsRequest
- (NSString *)uri{
    return @"api/Goods/type_goods";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAllGoodsModel class];
}
@end

@implementation MDYAllGoodsModel

@end
