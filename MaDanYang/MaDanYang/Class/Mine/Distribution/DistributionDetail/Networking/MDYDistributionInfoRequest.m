//
//  MDYDistributionInfoRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYDistributionInfoRequest.h"

@implementation MDYDistributionInfoRequest
- (NSString *)uri{
    return @"api/Distribution/info";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYDistributionInfoModel class];
}
@end

@implementation MDYDistributionInfoListModel
@end

@implementation MDYDistributionInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"list" : [MDYDistributionInfoListModel class]};
}
@end
