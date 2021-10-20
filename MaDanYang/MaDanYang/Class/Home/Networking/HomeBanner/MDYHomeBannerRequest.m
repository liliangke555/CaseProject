//
//  MDYHomeBannerRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYHomeBannerRequest.h"

@implementation MDYHomeBannerRequest
- (NSString *)uri{
    return @"api/Advertising/index_ad";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYHomeBannerModel class];
}
@end

@implementation MDYHomeBannerModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"id"};
}
@end
