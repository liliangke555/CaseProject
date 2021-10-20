//
//  MDYPutQuestionInfoRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/27.
//

#import "MDYPutQuestionInfoRequest.h"

@implementation MDYPutQuestionInfoRequest
- (NSString *)uri{
    return @"api/PutQuestions/putQuestionsinifo";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPutQuestionInfoModel class];
}
@end

@implementation MDYPutQuestionInfoModel

@end
