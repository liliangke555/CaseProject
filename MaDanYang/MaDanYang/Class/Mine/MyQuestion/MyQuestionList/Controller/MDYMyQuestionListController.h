//
//  MDYMyQuestionListController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyQuestionListController : CKBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger indexType; // 0 = 全部 1 = 我发起的 2 = 我购买的
@end

NS_ASSUME_NONNULL_END
