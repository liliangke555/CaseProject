//
//  MDYPayOfflineReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYPayOfflineReqeust.h"

@implementation MDYPayOfflineReqeust
- (NSString *)uri{
    return @"api/Pay/payOffline";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPayOfflineModel class];
}
@end

@implementation MDYPayOfflineModel

@end
