//
//  MDYMyOrderListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/29.
//

#import "MDYMyOrderListRequest.h"

@implementation MDYMyOrderListRequest
- (NSString *)uri{
    return @"api/MyOrder/orderlist";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyOrderListModel class];
}
@end

@implementation MDYMyOrderListModel

@end
