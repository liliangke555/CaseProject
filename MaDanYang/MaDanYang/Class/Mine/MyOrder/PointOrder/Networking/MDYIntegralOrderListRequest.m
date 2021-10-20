//
//  MDYIntegralOrderListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYIntegralOrderListRequest.h"

@implementation MDYIntegralOrderListRequest
- (NSString *)uri{
    return @"api/IntegralOrder/orderlist";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIntegralOrderListModel class];
}
@end

@implementation MDYIntegralOrderListModel

@end
