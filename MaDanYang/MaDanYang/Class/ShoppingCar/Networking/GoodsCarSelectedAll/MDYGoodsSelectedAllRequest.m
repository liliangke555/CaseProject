//
//  MDYGoodsSelectedAllRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYGoodsSelectedAllRequest.h"

@implementation MDYGoodsSelectedAllRequest
- (NSString *)uri{
    return @"api/GoodsCar/whole_ok";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsAllMoneyModel class];
}
@end
