//
//  MDYIMGenUserSigRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/25.
//

#import "MDYIMGenUserSigRequest.h"

@implementation MDYIMGenUserSigRequest
- (NSString *)uri{
    return @"api/TencentIm/getUserSig";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYIMGenUserSigModel class];
}
@end

@implementation MDYIMGenUserSigModel

@end
