//
//  MDYMyGuidanceListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYMyGuidanceListRequest.h"

@implementation MDYMyGuidanceListRequest
- (NSString *)uri{
    return @"api/Guidance/myguidance";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyGuidanceListModel class];
}
@end

@implementation MDYMyGuidanceListModel

@end
