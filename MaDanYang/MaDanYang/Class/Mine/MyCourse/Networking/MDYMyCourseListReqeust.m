//
//  MDYMyCourseListReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYMyCourseListReqeust.h"

@implementation MDYMyCourseListReqeust
- (NSString *)uri{
    return @"api/MyCurriculum/myCurriculum";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyCourseListModel class];
}
@end

@implementation MDYMyCourseListModel

@end
