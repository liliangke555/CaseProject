//
//  MDYGoodsGroupRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYGoodsGroupRequest.h"
#import "MDYAllGoodsRequest.h"
@implementation MDYGoodsGroupRequest
- (NSString *)uri{
    return @"api/Grooup/goods_grooup";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAllGoodsModel class];
}
@end
