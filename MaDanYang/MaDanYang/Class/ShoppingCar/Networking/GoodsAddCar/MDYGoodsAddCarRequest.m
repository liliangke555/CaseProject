//
//  MDYGoodsAddCarRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYGoodsAddCarRequest.h"

@implementation MDYGoodsAddCarRequest
- (NSString *)uri{
    return @"api/GoodsCar/goods_addcat";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsAddCarModel class];
}
@end

@implementation MDYGoodsAddCarModel

@end
