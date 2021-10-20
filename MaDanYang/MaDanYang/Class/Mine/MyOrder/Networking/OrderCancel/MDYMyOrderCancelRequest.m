//
//  MDYMyOrderCancelRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/29.
//

#import "MDYMyOrderCancelRequest.h"

@implementation MDYMyOrderCancelRequest
- (NSString *)uri{
    return @"api/MyOrder/order_del";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYMyOrderCancelModel class];
}
@end

@implementation MDYMyOrderCancelModel

@end
