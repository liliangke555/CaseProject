//
//  MDYCourseGoodsReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYCourseGoodsReqeust.h"

@implementation MDYCourseGoodsReqeust
- (NSString *)uri{
    return @"api/CurriculumInfo/curriculum_goods";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCourseGoodsModel class];
}
@end

@implementation MDYCourseGoodsModel

@end
