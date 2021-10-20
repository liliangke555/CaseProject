//
//  MDYObsLiveListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYObsLiveListRequest.h"

@implementation MDYObsLiveListRequest
- (NSString *)uri{
    return @"api/ObsLive/obsLive";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYObsLiveListModel class];
}
@end

@implementation MDYObsLiveListModel

@end
