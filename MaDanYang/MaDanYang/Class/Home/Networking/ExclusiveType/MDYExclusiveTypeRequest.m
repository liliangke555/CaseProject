//
//  MDYExclusiveTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYExclusiveTypeRequest.h"
#import "MDYFreeCurriculumTypeRequest.h"
@implementation MDYExclusiveTypeRequest
- (NSString *)uri{
    return @"api/Curriculum/pay_courses_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYFreeCurriculumTypeModel class];
}
@end
