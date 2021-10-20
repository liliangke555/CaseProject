//
//  MDYIntegralCourseListReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYIntegralCourseListReqeust.h"

@implementation MDYIntegralCourseListReqeust
- (NSString *)uri{
    return @"api/IntegralGoods/courses";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIntegralCourseListModel class];
}
@end

@implementation MDYIntegralCourseListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
