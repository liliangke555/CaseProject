//
//  MDYAllCourseTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYAllCourseTypeRequest.h"

@implementation MDYAllCourseTypeRequest
- (NSString *)uri{
    return @"api/Curriculum/courses_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYFreeCurriculumTypeModel class];
}
@end
