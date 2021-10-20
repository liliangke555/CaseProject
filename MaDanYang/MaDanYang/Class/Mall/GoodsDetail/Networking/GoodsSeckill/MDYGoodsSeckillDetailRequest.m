//
//  MDYGoodsSeckillDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/15.
//

#import "MDYGoodsSeckillDetailRequest.h"
#import "MDYGoodsDetailRequest.h"
@implementation MDYGoodsSeckillDetailRequest
- (NSString *)uri{
    return @"api/Seckill/goods_info";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGoodsDetailModel class];
}
@end
