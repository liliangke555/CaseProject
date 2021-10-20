//
//  MDYAllCourseRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYAllCourseRequest.h"
@implementation MDYAllCourseRequest
- (NSString *)uri{
    return @"api/Curriculum/courses";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAllCourseModel class];
}
@end

@implementation MDYAllCourseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
