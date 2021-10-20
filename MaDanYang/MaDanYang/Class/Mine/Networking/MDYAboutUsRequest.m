//
//  MDYAboutUsRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYAboutUsRequest.h"

@implementation MDYAboutUsRequest
- (NSString *)uri{
    return @"api/AboutUs/about_us";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYAboutUsModel class];
}
@end
@implementation MDYAboutUsModel

@end
