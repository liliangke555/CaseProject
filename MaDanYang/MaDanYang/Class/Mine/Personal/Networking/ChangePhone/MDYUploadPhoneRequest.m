//
//  MDYUploadPhoneRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYUploadPhoneRequest.h"

@implementation MDYUploadPhoneRequest
- (NSString *)uri{
    return @"api/User/upphone";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYUploadPhoneModel class];
}
@end

@implementation MDYUploadPhoneModel

@end
