//
//  MDYUploadImageRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYUploadImageRequest.h"

@implementation MDYUploadImageRequest
- (NSString *)uri{
    return @"api/UploadFiles/upload";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYUploadImageModel class];
}
@end
@implementation MDYUploadImageModel

@end
