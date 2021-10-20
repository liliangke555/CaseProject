//
//  MDYSecondaryDistributionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYSecondaryDistributionRequest.h"

@implementation MDYSecondaryDistributionRequest
- (NSString *)uri{
    return @"api/Distribution/secondaryDistribution";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYSecondaryDistributionModel class];
}
@end

@implementation MDYSecondaryDistributionModel


@end
