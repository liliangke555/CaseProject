//
//  MDYCourseSeckillDetailRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/15.
//

#import "MDYCourseSeckillDetailRequest.h"
#import "MDYCourseDetailRequest.h"
@implementation MDYCourseSeckillDetailRequest
- (NSString *)uri{
    return @"api/Seckill/infoCurriculum";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCourseDetailModel class];
}
@end
