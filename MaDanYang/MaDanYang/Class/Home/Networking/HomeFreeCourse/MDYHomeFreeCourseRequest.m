//
//  MDYHomeFreeCourseRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYHomeFreeCourseRequest.h"

@implementation MDYHomeFreeCourseRequest
- (NSString *)uri{
    return @"api/CurriculumIndex/free_courses";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYFreeCourseModel class];
}
@end
