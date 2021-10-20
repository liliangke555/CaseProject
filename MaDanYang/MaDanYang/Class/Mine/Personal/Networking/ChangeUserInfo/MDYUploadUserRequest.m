//
//  MDYUploadUserRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYUploadUserRequest.h"

@implementation MDYUploadUserRequest
- (NSString *)uri{
    return @"api/User/upuser";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYUploadUserModel class];
}
@end

@implementation MDYUploadUserModel

@end
