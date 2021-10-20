//
//  MDYCancelGuidanceRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYCancelGuidanceRequest.h"

@implementation MDYCancelGuidanceRequest
- (NSString *)uri{
    return @"api/Guidance/no_guidance";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCancelGuidanceModel class];
}
@end

@implementation MDYCancelGuidanceModel

@end
