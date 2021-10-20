//
//  MDYCourseGroupOrderRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYCourseGroupOrderRequest.h"
#import "MDYCoursePreviewOrderRequest.h"
@implementation MDYCourseGroupOrderRequest
- (NSString *)uri{
    return @"api/MyGrooup/curriculumOrderc";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCoursePreviewOrderModel class];
}
@end
