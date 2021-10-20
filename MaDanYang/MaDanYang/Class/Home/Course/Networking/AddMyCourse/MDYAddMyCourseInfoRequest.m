//
//  MDYAddMyCourseInfoRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/17.
//

#import "MDYAddMyCourseInfoRequest.h"

@implementation MDYAddMyCourseInfoRequest
- (NSString *)uri{
    return @"api/MyCurriculum/addmyCurriculuminfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAddMyCourseInfoModel class];
}
@end

@implementation MDYAddMyCourseInfoModel

@end
