//
//  MDYTimeLimtedCurriculunController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYTimeLimtedCurriculunController : CKBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^refreshCountDownTime)(NSInteger time);
@end

NS_ASSUME_NONNULL_END
