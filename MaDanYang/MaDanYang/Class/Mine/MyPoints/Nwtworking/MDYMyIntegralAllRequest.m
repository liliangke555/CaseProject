//
//  MDYMyIntegralAllRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYMyIntegralAllRequest.h"

@implementation MDYMyIntegralAllRequest
- (NSString *)uri{
    return @"api/Integral/typelist";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyIntegralAllModel class];
}
@end

@implementation MDYMyIntegralAllModel

@end
