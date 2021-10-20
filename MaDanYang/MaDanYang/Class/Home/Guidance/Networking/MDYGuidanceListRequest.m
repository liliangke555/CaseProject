//
//  MDYGuidanceListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/5.
//

#import "MDYGuidanceListRequest.h"

@implementation MDYGuidanceListRequest
- (NSString *)uri{
    return @"api/Guidance/postlist";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYGuidanceListModel class];
}
@end

@implementation MDYGuidanceListModel

@end
