//
//  MDYAddPutQuestionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYAddPutQuestionRequest.h"

@implementation MDYAddPutQuestionRequest
- (NSString *)uri{
    return @"api/PutQuestions/addPutQuestionsAdmin";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYAddPutQuestionModel class];
}
@end

@implementation MDYAddPutQuestionModel

@end
