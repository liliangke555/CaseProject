//
//  MDYPrimaryDistributionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYPrimaryDistributionRequest.h"

@implementation MDYPrimaryDistributionRequest
- (NSString *)uri{
    return @"api/Distribution/primaryDistribution";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYPrimaryDistributionModel class];
}
@end

@implementation MDYPrimaryDistributionModel

@end
