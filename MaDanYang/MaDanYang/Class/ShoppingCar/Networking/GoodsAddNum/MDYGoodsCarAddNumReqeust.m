//
//  MDYGoodsCarAddNumReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYGoodsCarAddNumReqeust.h"

@implementation MDYGoodsCarAddNumReqeust
- (NSString *)uri{
    return @"api/GoodsCar/car_addcat";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsCarAddNumModel class];
}
@end

@implementation MDYGoodsCarAddNumModel

@end
