//
//  MDYEstablishGroupCourseReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYEstablishGroupCourseReqeust.h"

@implementation MDYEstablishGroupCourseReqeust
- (NSString *)uri{
    return @"api/MyGrooup/addcurriculumOrderc";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYEstablishGroupCourseModel class];
}
@end

@implementation MDYEstablishGroupCourseModel

@end
