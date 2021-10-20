//
//  MDYMyCourseStudyRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYMyCourseStudyRequest.h"

@implementation MDYMyCourseStudyRequest
- (NSString *)uri{
    return @"api/MyCurriculum/study";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyCourseStudyModel class];
}
@end

@implementation MDYMyCourseStudyModel

@end
