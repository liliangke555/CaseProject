//
//  MDYCourseDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYCourseDetailRequest.h"

@implementation MDYCourseDetailRequest
- (NSString *)uri{
    return @"api/CurriculumInfo/info";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCourseDetailModel class];
}
@end

@implementation MDYCourseDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
