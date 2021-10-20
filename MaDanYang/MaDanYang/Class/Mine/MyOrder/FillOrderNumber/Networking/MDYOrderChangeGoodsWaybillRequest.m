//
//  MDYOrderChangeGoodsWaybillRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYOrderChangeGoodsWaybillRequest.h"

@implementation MDYOrderChangeGoodsWaybillRequest
- (NSString *)uri{
    return @"api/MyOrder/change_goodsnum";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYOrderChangeGoodsWaybillModel class];
}
@end

@implementation MDYOrderChangeGoodsWaybillModel

@end
