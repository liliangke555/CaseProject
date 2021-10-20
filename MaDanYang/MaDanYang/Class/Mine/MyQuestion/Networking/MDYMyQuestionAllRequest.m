//
//  MDYMyQuestionAllRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYMyQuestionAllRequest.h"

@implementation MDYMyQuestionAllRequest
- (NSString *)uri{
    return @"api/PutQuestions/myQuestionsList";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyQuestionAllModel class];
}
@end

@implementation MDYMyQuestionAllModel

@end
