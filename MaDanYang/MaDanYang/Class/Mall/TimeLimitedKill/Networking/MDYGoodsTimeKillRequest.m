//
//  MDYGoodsTimeKillRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYGoodsTimeKillRequest.h"

@implementation MDYGoodsTimeKillRequest
- (NSString *)uri{
    return @"api/Seckill/goods_seckill";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGoodsTimeKillModel class];
}
@end

@implementation MDYGoodsTimeKillModel

@end
