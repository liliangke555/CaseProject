//
//  MDYQuestionAnswerAreaRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYQuestionAnswerAreaRequest.h"

@implementation MDYQuestionAnswerAreaRequest
- (NSString *)uri{
    return @"api/PutQuestions/putQuestionss";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYQuestionAnswerAreaModel class];
}
@end

@implementation MDYQuestionAnswerAreaModel

@end
