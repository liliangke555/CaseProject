//
//  MDYQRBangdingRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYQRBangdingRequest.h"

@implementation MDYQRBangdingRequest
- (NSString *)uri{
    return @"api/Share/bangding";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYQRBangdingModel class];
}
@end

@implementation MDYQRBangdingModel

@end
