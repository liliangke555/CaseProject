//
//  MDYGetGuidanceIntegralRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYGetGuidanceIntegralRequest.h"

@implementation MDYGetGuidanceIntegralRequest
- (NSString *)uri{
    return @"api/Guidance/getintegral";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGetGuidanceIntegralModel class];
}
@end


@implementation MDYGetGuidanceIntegralModel

@end
