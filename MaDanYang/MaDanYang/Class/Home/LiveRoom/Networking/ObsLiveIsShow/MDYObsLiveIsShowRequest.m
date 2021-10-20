//
//  MDYObsLiveIsShowRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/11.
//

#import "MDYObsLiveIsShowRequest.h"

@implementation MDYObsLiveIsShowRequest
- (NSString *)uri{
    return @"api/ObsLive/is_show";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYObsLiveIsShowModel class];
}
@end

@implementation MDYObsLiveIsShowModel

@end
