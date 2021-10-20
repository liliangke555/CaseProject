//
//  MDYFreeCurriculumTypeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYFreeCurriculumTypeRequest.h"

@implementation MDYFreeCurriculumTypeRequest
- (NSString *)uri{
    return @"api/CurriculumFree/free_courses_type";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYFreeCurriculumTypeModel class];
}
@end

@implementation MDYFreeCurriculumTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
