//
//  MDYAllGoodsTypeRequst.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYAllGoodsTypeRequst.h"

@implementation MDYAllGoodsTypeRequst
- (NSString *)uri{
    return @"api/Goods/goods_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAllGoodsTypeModel class];
}
@end

@implementation MDYAllGoodsTypeModel

@end
