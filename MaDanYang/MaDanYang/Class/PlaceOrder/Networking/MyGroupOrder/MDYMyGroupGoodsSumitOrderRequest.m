//
//  MDYMyGroupGoodsSumitOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYMyGroupGoodsSumitOrderRequest.h"

@implementation MDYMyGroupGoodsSumitOrderRequest
- (NSString *)uri{
    return @"api/MyGrooup/addGoodsGrooup";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYMyGroupGoodsSumitOrderModel class];
}
@end

@implementation MDYMyGroupGoodsSumitOrderModel

@end
