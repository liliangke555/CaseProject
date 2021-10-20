//
//  MDYCourseTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYCourseTypeRequest.h"

@implementation MDYCourseTypeRequest
- (NSString *)uri{
    return @"api/Curriculum/courses_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCourseTypeModel class];
}
@end

@implementation MDYCourseTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
