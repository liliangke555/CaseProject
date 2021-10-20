//
//  MDYMallHomeReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYMallHomeReqeust.h"

@implementation MDYMallHomeReqeust
- (NSString *)uri{
    return @"api/GoodsIndex/goods_index";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMallHomeModel class];
}
@end

@implementation MDYMallHomeModel

@end
