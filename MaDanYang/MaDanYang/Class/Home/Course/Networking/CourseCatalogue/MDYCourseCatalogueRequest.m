//
//  MDYCourseCatalogueRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYCourseCatalogueRequest.h"

@implementation MDYCourseCatalogueRequest
- (NSString *)uri{
    return @"api/CurriculumInfo/info_catalog";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYCourseCatalogueModel class];
}
@end
@implementation MDYCourseCatalogueModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
