//
//  MDYSearchCurriculumRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/30.
//

#import "MDYSearchCurriculumRequest.h"

@implementation MDYSearchCurriculumRequest
- (NSString *)uri{
    return @"api/Search/searchCurriculum";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYSearchCurriculumModel class];
}
@end

@implementation MDYSearchCurriculumModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
