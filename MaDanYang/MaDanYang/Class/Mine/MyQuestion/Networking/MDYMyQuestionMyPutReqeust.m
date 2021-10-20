//
//  MDYMyQuestionMyPutReqeust.m
//  MaDanYang
//
//  Created by kckj on 2021/7/24.
//

#import "MDYMyQuestionMyPutReqeust.h"

@implementation MDYMyQuestionMyPutReqeust
- (NSString *)uri{
    return @"api/PutQuestions/myPutQuestions";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYMyQuestionMyPutModel class];
}
@end

@implementation MDYMyQuestionMyPutModel

@end
