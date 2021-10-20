//
//  MDYObsLiveinfoRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/11.
//

#import "MDYObsLiveinfoRequest.h"

@implementation MDYObsLiveinfoRequest
- (NSString *)uri{
    return @"api/ObsLive/obsLiveinfo";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYObsLiveinfoModel class];
}
@end

@implementation MDYObsLiveinfoModel

@end
