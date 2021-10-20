//
//  MDYUploadAppRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/9/15.
//

#import "MDYUploadAppRequest.h"

@implementation MDYUploadAppRequest
- (NSString *)uri{
    return @"api/UpdateApp/toUpdate";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYUploadAppModel class];
}
@end

@implementation MDYUploadAppModel

@end

@implementation MDYUploadAppDetailModel

@end
