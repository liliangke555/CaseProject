//
//  MDYGuidanceTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/6.
//

#import "MDYGuidanceTypeRequest.h"

@implementation MDYGuidanceTypeRequest
- (NSString *)uri{
    return @"api/Guidance/guidance_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGuidanceTypeModel class];
}
@end

@implementation MDYGuidanceTypeModel

@end
