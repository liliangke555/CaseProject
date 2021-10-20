//
//  MDYSearchGoodsRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/31.
//

#import "MDYSearchGoodsRequest.h"

@implementation MDYSearchGoodsRequest
- (NSString *)uri{
    return @"api/Search/searchGoods";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYSearchGoodsModel class];
}
@end

@implementation MDYSearchGoodsModel

@end
