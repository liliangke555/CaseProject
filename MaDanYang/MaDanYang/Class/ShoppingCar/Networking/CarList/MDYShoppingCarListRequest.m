//
//  MDYShoppingCarListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYShoppingCarListRequest.h"

@implementation MDYShoppingCarListRequest
- (NSString *)uri{
    return @"api/GoodsCar/car_list";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYShoppingCarListModel class];
}
@end

@implementation MDYShoppingCarListModel

@end
