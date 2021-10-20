//
//  MDYQuestionDetailController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYQuestionDetailController : CKBaseViewController
@property (nonatomic, assign, getter=isMySelf) BOOL mySelf;
@property (nonatomic, copy) NSString *questionId;
@end

NS_ASSUME_NONNULL_END
