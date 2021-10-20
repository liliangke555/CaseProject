//
//  MDYGoodsCarCancelAllRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYGoodsCarCancelAllRequest.h"
#import "MDYGoodsCarSelectedOrCancelReqeust.h"
@implementation MDYGoodsCarCancelAllRequest
- (NSString *)uri{
    return @"/api/GoodsCar/whole_no";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsAllMoneyModel class];
}
@end
