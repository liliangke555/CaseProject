//
//  MDYMyCourseInfoRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYMyCourseInfoRequest.h"

@implementation MDYMyCourseInfoRequest
- (NSString *)uri{
    return @"api/MyCurriculum/myCurriculuminfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyCourseInfoModel class];
}
@end

@implementation MDYMyCourseInfoModel

@end
