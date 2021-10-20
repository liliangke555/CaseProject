//
//  MDYHomeExclusiveCourseRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYHomeExclusiveCourseRequest.h"

@implementation MDYHomeExclusiveCourseRequest
- (NSString *)uri{
    return @"api/CurriculumIndex/pay_courses";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYHomeExclusiveCourseModel class];
}
@end

@implementation MDYHomeExclusiveCourseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
