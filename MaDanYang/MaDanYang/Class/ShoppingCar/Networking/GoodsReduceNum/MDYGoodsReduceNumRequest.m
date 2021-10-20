//
//  MDYGoodsReduceNumRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYGoodsReduceNumRequest.h"
#import "MDYGoodsCarAddNumReqeust.h"
@implementation MDYGoodsReduceNumRequest
- (NSString *)uri{
    return @"api/GoodsCar/car_reducecat";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsCarAddNumModel class];
}
@end
