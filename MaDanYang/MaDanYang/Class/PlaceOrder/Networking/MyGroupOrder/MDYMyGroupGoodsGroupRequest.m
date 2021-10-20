//
//  MDYMyGroupGoodsGroupRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYMyGroupGoodsGroupRequest.h"
#import "MDYPlaceOrderRequest.h"
@implementation MDYMyGroupGoodsGroupRequest
- (NSString *)uri{
    return @"api/MyGrooup/goodsOrder";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPlaceOrderModel class];
}
@end
