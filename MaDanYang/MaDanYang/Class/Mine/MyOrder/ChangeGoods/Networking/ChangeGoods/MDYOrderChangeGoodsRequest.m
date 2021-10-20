//
//  MDYOrderChangeGoodsRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYOrderChangeGoodsRequest.h"

@implementation MDYOrderChangeGoodsRequest
- (NSString *)uri{
    return @"api/MyOrder/change_goods";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYOrderChangeGoodsModel class];
}
@end

@implementation MDYOrderChangeGoodsModel

@end
