//
//  MDYTeacherPutQuestionRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/2.
//

#import "MDYTeacherPutQuestionRequest.h"

@implementation MDYTeacherPutQuestionRequest
- (NSString *)uri{
    return @"api/PutQuestions/teacherPutQuestions";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYTeacherPutQuestionModel class];
}
@end

@implementation MDYTeacherPutQuestionModel

@end
