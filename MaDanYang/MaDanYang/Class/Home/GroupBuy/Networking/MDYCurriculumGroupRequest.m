//
//  MDYCurriculumGroupRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/20.
//

#import "MDYCurriculumGroupRequest.h"

@implementation MDYCurriculumGroupRequest
- (NSString *)uri{
    return @"api/Grooup/curriculum_grooup";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCurriculumGroupModel class];
}
@end

@implementation MDYCurriculumGroupModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
