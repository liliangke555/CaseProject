//
//  MDYToQuestionController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "CKBaseViewController.h"
#import "MDYTeacherListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYToQuestionController : CKBaseViewController
@property (nonatomic, assign) BOOL isToTeacher;
@property (nonatomic, strong) MDYTeacherListModel *teacherModel;
@end

NS_ASSUME_NONNULL_END
