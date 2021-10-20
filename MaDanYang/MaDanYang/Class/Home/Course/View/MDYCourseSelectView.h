//
//  MDYCourseSelectView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseSelectView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void(^didSelected)(NSInteger index);
@property (nonatomic, copy) void(^didPushCertification)(void);
@end

NS_ASSUME_NONNULL_END
