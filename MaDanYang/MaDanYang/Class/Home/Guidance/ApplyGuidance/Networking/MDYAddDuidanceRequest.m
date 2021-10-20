//
//  MDYAddDuidanceRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/6.
//

#import "MDYAddDuidanceRequest.h"

@implementation MDYAddDuidanceRequest
- (NSString *)uri{
    return @"api/Guidance/addguidance";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYAddDuidanceModel class];
}
@end

@implementation MDYAddDuidanceModel

@end
