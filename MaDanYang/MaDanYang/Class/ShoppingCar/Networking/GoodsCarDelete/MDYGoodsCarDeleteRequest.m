//
//  MDYGoodsCarDeleteRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/14.
//

#import "MDYGoodsCarDeleteRequest.h"

@implementation MDYGoodsCarDeleteRequest
- (NSString *)uri{
    return @"api/GoodsCar/del_car";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYGoodsCarDeleteModel class];
}
@end

@implementation MDYGoodsCarDeleteModel

@end
