//
//  MDYExcellentPutQuestionsRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYExcellentPutQuestionsRequest.h"

@implementation MDYExcellentPutQuestionsRequest
- (NSString *)uri{
    return @"api/PutQuestions/excellentPutQuestionss";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYExcellentPutQuestionsModel class];
}
@end

@implementation MDYExcellentPutQuestionsModel

@end
