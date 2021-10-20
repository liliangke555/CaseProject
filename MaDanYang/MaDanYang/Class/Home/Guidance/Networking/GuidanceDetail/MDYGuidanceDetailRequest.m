//
//  MDYGuidanceDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYGuidanceDetailRequest.h"

@implementation MDYGuidanceDetailRequest
- (NSString *)uri{
    return @"api/Guidance/postlistinfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGuidanceDetailModel class];
}
@end

@implementation MDYGuidanceDetailModel

@end
