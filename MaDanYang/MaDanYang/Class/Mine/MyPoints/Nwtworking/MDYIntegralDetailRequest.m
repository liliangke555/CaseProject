//
//  MDYIntegralDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYIntegralDetailRequest.h"

@implementation MDYIntegralDetailRequest
- (NSString *)uri{
    return @"api/Integral/typelistinfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIntegralDetailModel class];
}
@end

@implementation MDYIntegralDetailModel

@end
