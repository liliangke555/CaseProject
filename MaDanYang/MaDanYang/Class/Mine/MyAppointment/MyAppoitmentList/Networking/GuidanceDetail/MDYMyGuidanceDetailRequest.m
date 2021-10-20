//
//  MDYMyGuidanceDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYMyGuidanceDetailRequest.h"

@implementation MDYMyGuidanceDetailRequest
- (NSString *)uri{
    return @"api/Guidance/guidanceinfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyGuidanceDetailModel class];
}
@end

@implementation MDYMyGuidanceDetailModel

@end
