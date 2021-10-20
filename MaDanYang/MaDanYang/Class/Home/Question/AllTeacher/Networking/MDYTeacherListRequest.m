//
//  MDYTeacherListRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/31.
//

#import "MDYTeacherListRequest.h"

@implementation MDYTeacherListRequest
- (NSString *)uri{
    return @"api/PutQuestions/teacherList";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYTeacherListModel class];
}
@end

@implementation MDYTeacherListModel

@end
