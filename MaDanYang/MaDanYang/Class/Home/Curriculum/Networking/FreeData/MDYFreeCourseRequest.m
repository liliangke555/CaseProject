//
//  MDYFreeCourseRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYFreeCourseRequest.h"

@implementation MDYFreeCourseRequest
- (NSString *)uri{
    return @"api/CurriculumFree/free_courses";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYFreeCourseModel class];
}
@end

@implementation MDYFreeCourseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
