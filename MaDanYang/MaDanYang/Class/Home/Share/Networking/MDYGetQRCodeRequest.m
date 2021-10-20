//
//  MDYGetQRCodeRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYGetQRCodeRequest.h"

@implementation MDYGetQRCodeRequest
- (NSString *)uri{
    return @"api/Share/qrcoder";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGetQRCodeModel class];
}
@end
@implementation MDYGetQRCodeModel

@end
