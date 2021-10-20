//
//  MDYExclusiveTypeCourseRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/16.
//

#import "MDYExclusiveTypeCourseRequest.h"
#import "MDYAllCourseRequest.h"
@implementation MDYExclusiveTypeCourseRequest
- (NSString *)uri{
    return @"api/Curriculum/pay_courses";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAllCourseModel class];
}
@end
