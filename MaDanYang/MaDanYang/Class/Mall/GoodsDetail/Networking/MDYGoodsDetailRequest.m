//
//  MDYGoodsDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYGoodsDetailRequest.h"

@implementation MDYGoodsDetailRequest
- (NSString *)uri{
    return @"api/GoodsInfo/goods_info";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGoodsDetailModel class];
}
@end

@implementation MDYGoodsDetailModel

@end
