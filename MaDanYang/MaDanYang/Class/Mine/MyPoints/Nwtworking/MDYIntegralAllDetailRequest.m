//
//  MDYIntegralAllDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYIntegralAllDetailRequest.h"

@implementation MDYIntegralAllDetailRequest
- (NSString *)uri{
    return @"api/Integral/info";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIntegralAllDetailModel class];
}
@end

@implementation MDYIntegralAllDetailModel

@end
