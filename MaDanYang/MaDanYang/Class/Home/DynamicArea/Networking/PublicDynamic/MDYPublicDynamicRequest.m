//
//  MDYPublicDynamicRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYPublicDynamicRequest.h"

@implementation MDYPublicDynamicRequest
- (NSString *)uri{
    return @"api/DryingSheet/addDryingSheet";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPublicDynamicModel class];
}
@end

@implementation MDYPublicDynamicModel

@end
