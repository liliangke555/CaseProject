//
//  MDYCourseDetailController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseDetailController : CKBaseViewController
@property (nonatomic, assign) NSInteger courseType;  // 0 == 普通 ， 1 == 秒杀 ， 2 == 团购 3== 免费
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *seckillId;
@end

NS_ASSUME_NONNULL_END
