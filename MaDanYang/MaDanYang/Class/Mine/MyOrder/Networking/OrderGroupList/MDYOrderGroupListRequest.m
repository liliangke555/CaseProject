//
//  MDYOrderGroupListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYOrderGroupListRequest.h"
#import "MDYMyOrderListRequest.h"
@implementation MDYOrderGroupListRequest
- (NSString *)uri{
    return @"api/MyOrder/orderlistpt";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyOrderListModel class];
}
@end
