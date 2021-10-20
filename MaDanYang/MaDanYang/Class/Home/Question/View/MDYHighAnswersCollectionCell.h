//
//  MDYHighAnswersCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "MDYMyQuestionAllRequest.h"
#import "MDYMyQuestionMyPutReqeust.h"
#import "MDYMyQuestionMyBuyRequest.h"
#import "MDYTeacherPutQuestionRequest.h"
#import "MDYExcellentPutQuestionsRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYHighAnswersCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *headerImageUrl;
@property (nonatomic, copy) void(^didClickCheckButton)(void);
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) NSInteger coinNum;

@property (nonatomic, strong) MDYMyQuestionAllModel *allModel;
@property (nonatomic, strong) MDYMyQuestionMyPutModel *myPutModel;
@property (nonatomic, strong) MDYMyQuestionMyBuyModel *myBuyModel;
@property (nonatomic, strong) MDYTeacherPutQuestionModel *teacherAnswerModel;
@property (nonatomic, strong) MDYExcellentPutQuestionsModel *excellentModel;
@end

NS_ASSUME_NONNULL_END
