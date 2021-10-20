//
//  MDYMallBannerRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYMallBannerRequest.h"

@implementation MDYMallBannerRequest
- (NSString *)uri{
    return @"api/Advertising/goods_ad";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYHomeBannerModel class];
}
@end
