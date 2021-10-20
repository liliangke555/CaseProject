//
//  MDYGoodsCarSelectedOrCancelReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYGoodsCarSelectedOrCancelReqeust.h"

@implementation MDYGoodsCarSelectedOrCancelReqeust
- (NSString *)uri{
    return @"api/GoodsCar/ok_no";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsAllMoneyModel class];
}
@end

@implementation MDYGoodsAllMoneyModel

@end
