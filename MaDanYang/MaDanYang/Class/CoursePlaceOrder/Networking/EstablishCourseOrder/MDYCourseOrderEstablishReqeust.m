//
//  MDYCourseOrderEstablishReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/8/19.
//

#import "MDYCourseOrderEstablishReqeust.h"

@implementation MDYCourseOrderEstablishReqeust
- (NSString *)uri{
    return @"api/CurriculumOrder/orderEstablish";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYCourseOrderEstablishModel class];
}
@end

@implementation MDYCourseOrderEstablishModel

@end
